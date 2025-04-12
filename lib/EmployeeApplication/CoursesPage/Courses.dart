import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:meyar/util/BottomNav.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/EmployeeApplication/CoursesPage/CourseCard.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> allCourses = [];
  List<dynamic> suggestedCourses = [];
  List<dynamic> displayedCourses = [];
  Map<String, List<dynamic>> coursesByCategory = {};
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  Future<void> loadCourseData() async {
    try {
      // Load course data
      final String courseJson =
          await rootBundle.loadString('assets/courses.json');
      final courseData = json.decode(courseJson);
      allCourses = courseData['courses'];

      // Load suggested courses if available
      // Randomly select courses for suggestions
      final random = Random();
      const numberOfSuggestions = 6; // You can adjust this number

      // Create a copy of allCourses to avoid modifying the original list
      var coursesPool = List.from(allCourses);
      suggestedCourses = [];

      // Randomly select courses
      while (suggestedCourses.length < numberOfSuggestions &&
          coursesPool.isNotEmpty) {
        final randomIndex = random.nextInt(coursesPool.length);
        suggestedCourses.add(coursesPool[randomIndex]);
        coursesPool.removeAt(randomIndex);
      }

      // Organize courses by category
      coursesByCategory = {};
      for (var course in allCourses) {
        final category = course['category'];
        if (!coursesByCategory.containsKey(category)) {
          coursesByCategory[category] = [];
        }
        coursesByCategory[category]!.add(course);
      }

      setState(() {
        displayedCourses = allCourses;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading course data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedCourses = allCourses;
      });
      return;
    }

    // Create searchable items with weighted attributes
    final fuse = Fuzzy(
      allCourses,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            name: 'title',
            getter: (item) => (item as Map<String, dynamic>)['title'] ?? '',
            weight: 0.5,
          ),
          WeightedKey(
            name: 'category',
            getter: (item) => (item as Map<String, dynamic>)['category'] ?? '',
            weight: 0.3,
          ),
          WeightedKey(
            name: 'tags',
            getter: (item) =>
                (item as Map<String, dynamic>)['tags'].join(' ') ?? '',
            weight: 0.2,
          ),
        ],
      ),
    );

    final result = fuse.search(query);
    setState(() {
      displayedCourses = result.map((r) => r.item).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading courses...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppColors
                .backgroundColor), // Set the hamburger menu icon to white

        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          'Learning Hub',
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: isDesktop
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
      ),
      drawer: isDesktop ? const ResponsiveNavBar(index: 2) : null,
      bottomNavigationBar: !isDesktop ? const ResponsiveNavBar(index: 2) : null,
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
                    onChanged: searchCourses,
                    hintText: 'Search...',
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.secondaryColor,
                onRefresh: () async {
                  // Add refresh logic here
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.school,
                                color: AppColors.secondaryColor,
                                size: isDesktop ? 24 : 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Suggested Courses',
                              style: TextStyle(
                                fontSize: isDesktop ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return _buildCourseGrid(
                                constraints.maxWidth, isDesktop);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseGrid(double width, bool isDesktop) {
    // Calculate number of columns based on width
    int crossAxisCount = isDesktop ? (width ~/ 300).clamp(1, 4) : 1;
    double aspectRatio = isDesktop ? 0.8 : 0.9;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: displayedCourses.length,
      itemBuilder: (context, index) => CourseCard(
        course: displayedCourses[index],
      ),
    );
  }
}
