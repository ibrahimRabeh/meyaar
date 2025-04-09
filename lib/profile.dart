import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:meyar/Colors.dart';
import 'package:meyar/BottomNav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dummy data - In production, this would come from your JSON files
  final Map<String, dynamic> employeeData = {
    "employee": {
      "name": "Ahmed Fahad",
      "job_title": "Senior Data Analyst",
      "department": "Business Intelligence",
      "company": "TechCorp Solutions",
      "email": "Ahmed.Fahad@gmail.com",
      "profile_image": "assets/images/profile.jpg",
      "bio":
          "Experienced data analyst with a passion for transforming complex data into actionable insights. Specialized in business intelligence and performance optimization.",
      "joined_date": "2022-03-15",
    }
  };

  final List<Map<String, dynamic>> enrolledCourses = [
    {
      "id": "tech001",
      "title": "Advanced Cloud Computing",
      "progress": 0.75,
      "provider": {
        "name": "TechMaster Academy",
      },
      "image": "assets/images/Cloud.jpeg",
      "nextSession": "Tuesday, 6PM-8PM",
      "remainingModules": 2,
    },
    {
      "id": "tech002",
      "title": "Cybersecurity Fundamentals",
      "progress": 0.45,
      "provider": {
        "name": "TechMaster Academy",
      },
      "image": "assets/images/Cyper.jpeg",
      "nextSession": "Wednesday, 5PM-7PM",
      "remainingModules": 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final padding = isDesktop ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Perform sign-out logic here
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/portal',
                (route) => false,
              );
            },
          ),
        ],
        backgroundColor: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: isDesktop ? 80.0 : 60.0,
        leading: isDesktop
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 24 : 20,
          ),
        ),
      ),
      drawer: isDesktop ? ResponsiveNavBar(index: 0) : null,
      bottomNavigationBar: !isDesktop ? ResponsiveNavBar(index: 0) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildProfileInfo(isDesktop: true),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: _buildEnrolledCourses(isDesktop: true),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProfileInfo(isDesktop: false),
        const SizedBox(height: 24),
        _buildEnrolledCourses(isDesktop: false),
      ],
    );
  }

  Widget _buildProfileInfo({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
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
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: isDesktop ? 60 : 50,
                  backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: isDesktop ? 80 : 60,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              employeeData['employee']['name'],
              style: TextStyle(
                fontSize: isDesktop ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              employeeData['employee']['job_title'],
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoTile(
            icon: Icons.business,
            title: 'Company',
            value: employeeData['employee']['company'],
          ),
          _buildInfoTile(
            icon: Icons.category,
            title: 'Department',
            value: employeeData['employee']['department'],
          ),
          _buildInfoTile(
            icon: Icons.email,
            title: 'Email',
            value: employeeData['employee']['email'],
          ),
          _buildInfoTile(
            icon: Icons.calendar_today,
            title: 'Joined',
            value: 'March 15, 2022',
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            employeeData['employee']['bio'],
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledCourses({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enrolled Courses',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/Courses');
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.secondaryColor,
                ),
                label: Text(
                  'Browse More',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: enrolledCourses.length,
            itemBuilder: (context, index) {
              final course = enrolledCourses[index];
              return _buildCourseCard(course, isDesktop);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course, bool isDesktop) {
    final progress = course['progress'] as double;
    final progressPercentage = (progress * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.secondaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.school,
                  size: 30,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course['provider']['name'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Next: ${course['nextSession']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 5.0,
                animation: true,
                percent: progress,
                center: Text(
                  '$progressPercentage%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppColors.secondaryColor,
                backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${course['remainingModules']} modules remaining',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
