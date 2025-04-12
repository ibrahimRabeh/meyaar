import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

class QuizSummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> weaknesses = [
    {
      'area': 'Data Validation',
      'details':
          'Needs to improve data quality checks and validation procedures before analysis'
    },
    {
      'area': 'Advanced Analytics',
      'details':
          'Could enhance skills in predictive modeling and machine learning techniques'
    },
    {
      'area': 'Data Visualization',
      'details':
          'Room for improvement in creating more impactful and clear data visualizations'
    }
  ];

  final List<Map<String, dynamic>> recommendations;

  final List<Map<String, dynamic>> strengths = [
    {
      'area': 'SQL Proficiency',
      'details':
          'Excellent command of SQL for complex data querying and manipulation'
    },
    {
      'area': 'Statistical Analysis',
      'details':
          'Strong understanding of statistical methods and their applications'
    },
    {
      'area': 'Data Cleaning',
      'details': 'Highly skilled in preprocessing and cleaning large datasets'
    },
    {
      'area': 'Problem Solving',
      'details':
          'Demonstrates strong analytical thinking and problem-solving abilities'
    }
  ];

  final Map<String, dynamic> analysis;
  final Map<String, dynamic> employeeInfo;
  final VoidCallback onViewCourses;

  QuizSummaryPage({
    Key? key,
    required this.recommendations,
    required this.analysis,
    required this.employeeInfo,
    required this.onViewCourses,
  }) : super(key: key);

  build(BuildContext context) {
    final List<Map<String, dynamic>> strengths = this.strengths;
    final List<Map<String, dynamic>> weaknesses = this.weaknesses;
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final performanceAnalysis =
        analysis['performance_analysis'] as Map<String, dynamic>? ?? {};
    final overallAssessment =
        analysis['overall_assessment'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundColor,
                AppColors.primaryColor.withOpacity(0.05),
                AppColors.backgroundColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.0 : 20.0,
              vertical: 20.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity),
                child: Column(
                  children: [
                    _buildHeader(context, isDesktop),
                    const SizedBox(height: 30),
                    _buildOverallAssessment(overallAssessment, isDesktop),
                    const SizedBox(height: 30),
                    if (isDesktop)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildStrengthsSection(
                                strengths, // Use the strengths passed to constructor
                                isDesktop,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildWeaknessesSection(
                                weaknesses, // Use the weaknesses passed to constructor
                                isDesktop,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      _buildStrengthsSection(
                        strengths, // Use the strengths passed to constructor
                        isDesktop,
                      ),
                      const SizedBox(height: 20),
                      _buildWeaknessesSection(
                        weaknesses, // Use the weaknesses passed to constructor
                        isDesktop,
                      ),
                    ],
                    const SizedBox(height: 30),
                    const SizedBox(height: 40),
                    _buildActionButtons(context, isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                isDesktop ? 300 : double.infinity, // Limit width on desktop
          ),
          child: ElevatedButton(
            onPressed: onViewCourses,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 36),
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.school, size: 20),
                SizedBox(width: 10),
                Text('View Recommended Courses'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        Icon(
          Icons.analytics_rounded,
          size: isDesktop ? 80 : 60,
          color: AppColors.secondaryColor,
        ),
        const SizedBox(height: 20),
        Text(
          'Performance Analysis',
          style: TextStyle(
            fontSize: isDesktop ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          employeeInfo['name']?.toString() ?? 'Employee Analysis',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOverallAssessment(
      Map<String, dynamic> assessment, bool isDesktop) {
    final keyFindings =
        (assessment['key_findings'] as List?)?.cast<String>() ?? [];

    return Container(
      padding: EdgeInsets.all(isDesktop ? 30 : 20),
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
          Text(
            'Overall Assessment',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            assessment['summary']?.toString() ?? 'Assessment not available',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (keyFindings.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Key Findings',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...keyFindings.map((finding) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_right,
                        color: AppColors.secondaryColor,
                        size: isDesktop ? 24 : 20,
                      ),
                      Expanded(
                        child: Text(
                          finding,
                          style: TextStyle(
                            fontSize: isDesktop ? 14 : 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildStrengthsSection(
      List<Map<String, dynamic>> strengths, bool isDesktop) {
    return _buildSection(
      title: 'Strengths',
      items: strengths,
      icon: Icons.trending_up,
      color: Colors.green,
      isDesktop: isDesktop,
    );
  }

  Widget _buildWeaknessesSection(
      List<Map<String, dynamic>> weaknesses, bool isDesktop) {
    return _buildSection(
      title: 'Areas for Improvement',
      items: weaknesses,
      icon: Icons.trending_down,
      color: Colors.orange,
      isDesktop: isDesktop,
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required IconData icon,
    required Color color,
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 30 : 20),
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
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map((item) => _buildItemCard(item, color, isDesktop)),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      Map<String, dynamic> item, Color color, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['area']?.toString() ?? '',
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['details']?.toString() ?? '',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
