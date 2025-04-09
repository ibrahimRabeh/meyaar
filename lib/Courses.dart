import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:meyar/BottomNav.dart';
import 'package:meyar/Colors.dart';
import 'package:meyar/CoursesDetails.dart';

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
                    hintText: 'Search courses...',
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

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    course['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getLevelIcon(course['level']),
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course['level'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course['category'],
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildStat(
                          Icons.access_time,
                          course['duration'],
                        ),
                        const SizedBox(width: 16),
                        _buildStat(
                          Icons.people,
                          '${course['enrollmentCount']} enrolled',
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course['rating'].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLevelIcon(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Icons.fast_forward;
      case 'intermediate':
        return Icons.double_arrow;
      case 'advanced':
        return Icons.wifi_tethering;
      default:
        return Icons.arrow_forward;
    }
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
