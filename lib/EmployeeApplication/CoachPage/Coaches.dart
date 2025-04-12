import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:meyar/util/BottomNav.dart';
import 'package:meyar/EmployeeApplication/CoachPage/CoachCard.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/EmployeeApplication/CoachPage/SuggestedCoaches.dart';

class CoachesPage extends StatefulWidget {
  const CoachesPage({Key? key}) : super(key: key);

  @override
  _CoachesPageState createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  List<dynamic> allCoaches = [];
  List<dynamic> suggestedCoaches = [];
  List<dynamic> displayedCoaches = [];
  Map<String, List<dynamic>> coachesByCategory = {};
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadCoachData();
  }

  Future<void> loadCoachData() async {
    try {
      final String coachJson =
          await rootBundle.loadString('assets/coaches.json');
      final coachData = json.decode(coachJson);
      allCoaches = coachData['coaches'];

      // Organize coaches by category
      coachesByCategory = {};
      for (var coach in allCoaches) {
        final category = coach['category'];
        if (!coachesByCategory.containsKey(category)) {
          coachesByCategory[category] = [];
        }
        coachesByCategory[category]!.add(coach);
      }

      // Get suggested coaches (you can implement your own logic here)
      suggestedCoaches =
          allCoaches.where((coach) => coach['rating'] >= 4.8).toList();

      setState(() {
        displayedCoaches = allCoaches;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading coach data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchCoaches(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedCoaches = allCoaches;
      });
      return;
    }

    final fuse = Fuzzy(
      allCoaches,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            name: 'name',
            getter: (item) => (item as Map<String, dynamic>)['name'] ?? '',
            weight: 0.4,
          ),
          WeightedKey(
            name: 'expertise',
            getter: (item) =>
                (item as Map<String, dynamic>)['expertise'].join(' ') ?? '',
            weight: 0.3,
          ),
          WeightedKey(
            name: 'category',
            getter: (item) => (item as Map<String, dynamic>)['category'] ?? '',
            weight: 0.2,
          ),
          WeightedKey(
            name: 'tags',
            getter: (item) =>
                (item as Map<String, dynamic>)['tags'].join(' ') ?? '',
            weight: 0.1,
          ),
        ],
      ),
    );

    final result = fuse.search(query);
    setState(() {
      displayedCoaches = result.map((r) => r.item).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: const Text(
          'Find a Coach',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: MediaQuery.of(context).size.width >= 600
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
      ),
      drawer: MediaQuery.of(context).size.width >= 600
          ? ResponsiveNavBar(index: 1)
          : null,
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? ResponsiveNavBar(index: 1)
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.primaryColor.withOpacity(0.005),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  SearchBar(
                    controller: searchController,
                    onChanged: searchCoaches,
                    hintText: 'Search...',
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (suggestedCoaches.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Top Rated Coaches',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SuggestedCoaches(coaches: suggestedCoaches),
                        Divider(
                          height: 32,
                          color: AppColors.primaryColor.withOpacity(0.1),
                          thickness: 1,
                        ),
                      ],
                      if (searchController.text.isEmpty)
                        _buildCategorizedCoaches()
                      else
                        _buildSearchResults(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorizedCoaches() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: coachesByCategory.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${entry.key} Coaches',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 360,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    return CoachCard(coach: entry.value[index]);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children:
            displayedCoaches.map((coach) => CoachCard(coach: coach)).toList(),
      ),
    );
  }
}
