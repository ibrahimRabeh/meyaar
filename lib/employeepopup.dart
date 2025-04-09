import 'package:flutter/material.dart';
import 'package:meyar/Colors.dart';

class EmployeePopup extends StatelessWidget {
  final List<EmployeeData> employees = [
    EmployeeData(
      name: "Sarah Chen",
      role: "Frontend Developer",
      strengths: ["UI/UX expertise", "Fast learner", "Team collaboration"],
      weaknesses: ["Backend integration", "Time management"],
    ),
    EmployeeData(
      name: "Marcus Johnson",
      role: "Project Manager",
      strengths: [
        "Strategic planning",
        "Client communication",
        "Risk management"
      ],
      weaknesses: ["Technical depth", "Delegation"],
    ),
    EmployeeData(
      name: "Aisha Patel",
      role: "Data Analyst",
      strengths: [
        "Statistical analysis",
        "Data visualization",
        "Problem solving"
      ],
      weaknesses: ["Public speaking", "Documentation"],
    ),
    EmployeeData(
      name: "David Kim",
      role: "Backend Developer",
      strengths: [
        "System architecture",
        "Performance optimization",
        "Code quality"
      ],
      weaknesses: ["Frontend design", "Meeting deadlines"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 800
            ? (MediaQuery.of(context).size.width - 800) / 2
            : 16,
        vertical: 24,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: _buildEmployeeGrid(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: AppColors.secondaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Department Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${employees.length} Members',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.dividerColor,
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 640;
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: employees
              .map((employee) => SizedBox(
                    width: isDesktop
                        ? (constraints.maxWidth - 24) / 2
                        : constraints.maxWidth,
                    child: _buildEmployeeCard(employee),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildEmployeeCard(EmployeeData employee) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.secondaryColor.withOpacity(0.1),
                child: Text(
                  employee.name.split(' ').map((e) => e[0]).join(''),
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        employee.role,
                        style: TextStyle(
                          color: AppColors.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Key Strengths',
            items: employee.strengths,
            icon: Icons.stars_rounded,
            color: AppColors.successColor,
            bgColor: AppColors.successColor.withOpacity(0.1),
          ),
          SizedBox(height: 16),
          _buildSection(
            title: 'Growth Areas',
            items: employee.weaknesses,
            icon: Icons.trending_up_rounded,
            color: AppColors.errorColor,
            bgColor: AppColors.errorColor.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...items
            .map((item) => Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}

class EmployeeData {
  final String name;
  final String role;
  final List<String> strengths;
  final List<String> weaknesses;

  EmployeeData({
    required this.name,
    required this.role,
    required this.strengths,
    required this.weaknesses,
  });
}
