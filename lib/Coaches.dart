import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:meyar/BottomNav.dart';
import 'package:meyar/Colors.dart';
import 'package:meyar/CoachesDetails.dart';
import 'package:meyar/models/coache.dart';

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
                    hintText: 'Search courses...',
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
                        SuggestedCoachesSection(coaches: suggestedCoaches),
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

class CoachCard extends StatelessWidget {
  final Map<String, dynamic> coach;

  const CoachCard({Key? key, required this.coach}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Coach newcoach = Coach.fromJson(coach);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoachDetailsPage(coach: newcoach),
          ),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(coach['image']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coach['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          coach['title'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accentColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              coach['rating'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                coach['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (coach['expertise'] as List)
                    .take(3)
                    .map((expertise) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            expertise,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Spacer(),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${coach['clientCount']} clients',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'From ${coach['sessionTypes'][0]['currency']} ${coach['sessionTypes'][0]['price']}/session',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestedCoachesSection extends StatelessWidget {
  final List<dynamic> coaches;

  const SuggestedCoachesSection({Key? key, required this.coaches})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coaches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                CoachCard(coach: coaches[index]),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      style: TextStyle(color: AppColors.textPrimary),
    );
  }
}
