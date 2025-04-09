import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meyar/Colors.dart';
import 'package:meyar/employeepopup.dart';

// Data Models
class Department {
  final int id;
  final String name;
  final double averageScore;
  final List<Employee> employees;

  Department({
    required this.id,
    required this.name,
    required this.averageScore,
    required this.employees,
  });
}

class Employee {
  final int id;
  final String name;
  final String role;
  final double score;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.score,
  });
}

class HRDashboard extends StatefulWidget {
  @override
  _HRDashboardState createState() => _HRDashboardState();
}

class _HRDashboardState extends State<HRDashboard> {
  final ScrollController _scrollController = ScrollController();
  Department? selectedDepartment;

  final List<Department> departmentsData = [
    Department(
      id: 1,
      name: "Engineering",
      averageScore: 85,
      employees: [
        Employee(
            id: 1, name: "Ahmad Al-Sayed", role: "Senior Developer", score: 92),
        Employee(
            id: 2,
            name: "Fatima Hassan",
            role: "Frontend Developer",
            score: 88),
        Employee(
            id: 3, name: "Omar Khalil", role: "Backend Developer", score: 85),
        Employee(
            id: 4, name: "Layla Ibrahim", role: "DevOps Engineer", score: 90),
      ],
    ),
    Department(
      id: 2,
      name: "Marketing",
      averageScore: 78,
      employees: [
        Employee(
            id: 5, name: "Noura Ali", role: "Marketing Manager", score: 80),
        Employee(
            id: 6,
            name: "Sara Ahmed",
            role: "Social Media Specialist",
            score: 75),
        Employee(id: 7, name: "Ali Hassan", role: "SEO Specialist", score: 82),
        Employee(
            id: 8, name: "Hassan Omar", role: "Content Creator", score: 78),
      ],
    ),
    Department(
      id: 3,
      name: "Sales",
      averageScore: 70,
      employees: [
        Employee(id: 9, name: "Khaled Ali", role: "Sales Manager", score: 72),
        Employee(
            id: 10, name: "Nada Hassan", role: "Sales Executive", score: 68),
        Employee(
            id: 11, name: "Sami Ahmed", role: "Sales Executive", score: 70),
        Employee(id: 12, name: "Lina Omar", role: "Sales Executive", score: 75),
      ],
    ),
    Department(
      id: 4,
      name: "Finance",
      averageScore: 82,
      employees: [
        Employee(
            id: 13, name: "Hassan Ali", role: "Finance Manager", score: 85),
        Employee(id: 14, name: "Noura Hassan", role: "Accountant", score: 80),
        Employee(
            id: 15, name: "Sara Ahmed", role: "Financial Analyst", score: 78),
        Employee(id: 16, name: "Ali Omar", role: "Auditor", score: 85),
      ],
    ),
  ];

  final Map<String, dynamic> data = {
    'overall': {
      'totalEmployees': 38,
      'aiRecommendationAccuracy': 92,
      'skillGapsIdentified': 45,
      'skillGapsResolved': 32,
      'averageCompletionRate': 85,
      'averageTestScore': 78,
    },
    // Other data...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(isDesktop),
              SliverPadding(
                padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(isDesktop),
                      SizedBox(height: 24),
                      _buildDepartmentSection(isDesktop),
                      SizedBox(height: 24),
                      _buildStatCardsSection(isDesktop),
                      SizedBox(height: 24),
                      _buildChartsSection(isDesktop),
                      _buildChartsSection1(isDesktop),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(bool isDesktop) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryColor,
      pinned: true,
      expandedHeight: isDesktop ? 120.0 : 100.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'معيار',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/portal', (route) => false);
          },
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeaderSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.insights, color: AppColors.secondaryColor),
              SizedBox(width: 12),
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Track and analyze employee performance and department metrics',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isDesktop ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
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
                'Department Performance',
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text('Filter'),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop ? 2 : 1.8,
            ),
            itemCount: departmentsData.length,
            itemBuilder: (context, index) {
              final dept = departmentsData[index];
              return _buildDepartmentCard(dept, isDesktop);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(Department dept, bool isDesktop) {
    final isSelected = selectedDepartment?.id == dept.id;
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => EmployeePopup(),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.secondaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color:
                isSelected ? AppColors.secondaryColor : AppColors.dividerColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dept.name,
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${dept.employees.length} Employees',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: isDesktop ? 14 : 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getScoreColor(dept.averageScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dept.averageScore.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _getScoreColor(dept.averageScore),
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 16 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.successColor;
    if (score >= 70) return AppColors.secondaryColor;
    if (score >= 50) return AppColors.accentColor;
    return AppColors.errorColor;
  }

  Widget _buildStatCardsSection(bool isDesktop) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isDesktop ? 1.5 : 1.3,
      children: [
        _buildStatCard(
          icon: Icons.psychology,
          iconColor: AppColors.secondaryColor,
          title: 'AI Accuracy',
          value: data['overall']['aiRecommendationAccuracy'],
          Description: "Based on employee feedback",
          trend: 5.2,
          isUpTrend: true,
        ),
        _buildStatCard(
          icon: Icons.trending_up,
          iconColor: AppColors.successColor,
          title: 'Completion Rate',
          Description: "Of recommended courses",
          value: data['overall']['averageCompletionRate'],
          trend: 2.1,
          isUpTrend: true,
        ),
        _buildStatCard(
          icon: Icons.search,
          iconColor: AppColors.accentColor,
          title: 'Skill Gaps Identified',
          Description: "Across all departments",
          value: data['overall']['totalEmployees'],
          trend: 12,
          isUpTrend: true,
          isCurrency: false,
        ),
        _buildStatCard(
          icon: Icons.speed,
          iconColor: AppColors.errorColor,
          title: 'Avg Score',
          Description: "Across all departments",
          value: data['overall']['averageTestScore'],
          trend: 1.5,
          isUpTrend: false,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String Description,
    required num value,
    required double trend,
    required bool isUpTrend,
    bool isCurrency = false,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: 150), // Fixed height
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isUpTrend
                      ? AppColors.successColor.withOpacity(0.1)
                      : AppColors.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUpTrend ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isUpTrend
                          ? AppColors.successColor
                          : AppColors.errorColor,
                      size: 12,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '${trend.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isUpTrend
                            ? AppColors.successColor
                            : AppColors.errorColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  isCurrency
                      ? '\$${value.toStringAsFixed(2)}'
                      : value.toString(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Text(
                  Description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection1(bool isDesktop) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        Container(
          width: isDesktop
              ? (MediaQuery.of(context).size.width - 64) / 2
              : MediaQuery.of(context).size.width - 32,
          height: 400,
          child: _buildBarChart(),
        ),
        Container(
          width: isDesktop
              ? (MediaQuery.of(context).size.width - 64) / 2
              : MediaQuery.of(context).size.width - 32,
          height: 400,
          child: _buildRadarChart(),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Progress Over Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildLegendItem('Skill Gaps', AppColors.errorColor),
                SizedBox(width: 16),
                _buildLegendItem('Completion Rate', AppColors.secondaryColor),
                SizedBox(width: 16),
                _buildLegendItem('Test Scores', AppColors.successColor),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const titles = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              titles[value.toInt()],
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Skill Gaps Line (decreasing)
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 45),
                        FlSpot(1, 44),
                        FlSpot(2, 41),
                        FlSpot(3, 42),
                        FlSpot(4, 38),
                        FlSpot(5, 35),
                      ],
                      isCurved: true,
                      color: AppColors.errorColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppColors.errorColor,
                          );
                        },
                      ),
                    ),
                    // Completion Rate Line (increasing)
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 55),
                        FlSpot(1, 58),
                        FlSpot(2, 59),
                        FlSpot(3, 61),
                        FlSpot(4, 68),
                        FlSpot(5, 72),
                      ],
                      isCurved: true,
                      color: AppColors.secondaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppColors.secondaryColor,
                          );
                        },
                      ),
                    ),
                    // Test Scores Line (increasing)
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 60),
                        FlSpot(1, 63),
                        FlSpot(2, 67),
                        FlSpot(3, 65),
                        FlSpot(4, 71),
                        FlSpot(5, 75),
                      ],
                      isCurved: true,
                      color: AppColors.successColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppColors.successColor,
                          );
                        },
                      ),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Experience Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Employee experience levels',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: AppColors.primaryColor,
                      value: 35,
                      title: '35%',
                      radius: 100,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: AppColors.secondaryColor,
                      value: 45,
                      title: '45%',
                      radius: 100,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: AppColors.accentColor,
                      value: 20,
                      title: '20%',
                      radius: 100,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem('Senior Level', AppColors.primaryColor),
                _buildLegendItem('Mid Level', AppColors.secondaryColor),
                _buildLegendItem('Junior Level', AppColors.accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department Completion Rates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Training completion by department',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const departments = [
                            'HR',
                            'Dev',
                            'Marketing',
                            'Sales',
                            'Finance'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              departments[value.toInt()],
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _generateBarGroup(0, 90),
                    _generateBarGroup(1, 85),
                    _generateBarGroup(2, 82),
                    _generateBarGroup(3, 88),
                    _generateBarGroup(4, 87),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _generateBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: AppColors.secondaryColor,
          width: 20,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppColors.dividerColor,
          ),
        ),
      ],
    );
  }

// Usage:
  Widget _buildRadarChart() {
    return HexagonalRadarChart(
      values: [85, 75, 70, 80, 90],
      skills: [
        'Technical',
        'Communication',
        'Leadership',
        'Problem Solving',
        'Teamwork'
      ],
    );
  }

  Widget _buildChartsSection(bool isDesktop) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        Container(
          width: isDesktop
              ? (MediaQuery.of(context).size.width - 64) / 2
              : MediaQuery.of(context).size.width - 32,
          height: 400,
          child: _buildLineChart(),
        ),
        Container(
          width: isDesktop
              ? (MediaQuery.of(context).size.width - 64) / 2
              : MediaQuery.of(context).size.width - 32,
          height: 400,
          child: _buildPieChart(),
        ),
      ],
    );
  }
}

class HexagonalRadarChart extends StatelessWidget {
  final List<double> values;
  final List<String> skills;

  const HexagonalRadarChart({
    Key? key,
    required this.values,
    required this.skills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skill Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Department skill assessment',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: HexGridPainter(
                      gridColor: AppColors.dividerColor.withOpacity(0.3),
                    ),
                    child: const SizedBox.expand(),
                  ),
                  CustomPaint(
                    painter: HexRadarChartPainter(
                      values: values,
                      skills: skills,
                      dataColor: AppColors.secondaryColor,
                      textColor: AppColors.textPrimary,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexGridPainter extends CustomPainter {
  final Color gridColor;

  HexGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;

    final layers = [];
    final borderPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var layer in layers) {
      _drawHexBorder(canvas, center, radius * layer, borderPaint);
      _drawPercentageLabel(canvas, center, radius * layer, layer * 100);
    }
  }

  void _drawHexBorder(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const sides = 6;
    const startAngle = -pi / 2;

    for (int i = 0; i <= sides; i++) {
      final angle = startAngle + (2 * pi * i / sides);
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawPercentageLabel(
      Canvas canvas, Offset center, double radius, double percentage) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: '${percentage.toInt()}%',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 10,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + radius * cos(-pi / 2) - textPainter.width / 2,
        center.dy + radius * sin(-pi / 2) - textPainter.height,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HexRadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> skills;
  final Color dataColor;
  final Color textColor;

  HexRadarChartPainter({
    required this.values,
    required this.skills,
    required this.dataColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;
    final points = skills.length;
    final angleStep = 2 * pi / points;

    // Draw axis lines
    _drawAxisLines(canvas, center, radius, points, angleStep);

    // Draw data polygon
    _drawDataPolygon(canvas, center, radius, points, angleStep);

    // Draw labels
    _drawSkillLabels(canvas, center, radius, points, angleStep);
  }

  void _drawAxisLines(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
        paint,
      );
    }
  }

  void _drawDataPolygon(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final path = Path();

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      final value = values[i] / 100;
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = dataColor.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = dataColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawSkillLabels(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      final point = Offset(
        center.dx + radius * 1.2 * cos(angle),
        center.dy + radius * 1.2 * sin(angle),
      );

      textPainter.text = TextSpan(
        text: '${skills[i]}\n${values[i].toInt()}%',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
