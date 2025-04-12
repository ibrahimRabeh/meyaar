import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meyar/DashBoard/Charts/BiChart.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/models/Department.dart';
import 'package:meyar/DashBoard/Department/DepartmentData.dart';
import 'package:meyar/DashBoard/Department/DepartmentSection.dart';
import 'package:meyar/DashBoard/models/Employee.dart';
import 'package:meyar/DashBoard/Charts/HexaRadarChartClass.dart';
import 'package:meyar/DashBoard/Items/LegendItem.dart';
import 'package:meyar/EmployeeApplication/CoursesPage/LineChart.dart';
import 'package:meyar/DashBoard/Items/StatCard.dart';
import 'package:meyar/DashBoard/PopUp/employeepopup.dart';

// Data Models

class HRDashboard extends StatefulWidget {
  @override
  _HRDashboardState createState() => _HRDashboardState();
}

class _HRDashboardState extends State<HRDashboard> {
  final ScrollController _scrollController = ScrollController();
  Department? selectedDepartment;

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
                      DepartmentSection(isDesktop),
                      SizedBox(height: 24),
                      buildStatCardsSection(isDesktop, data),
                      SizedBox(height: 24),
                      _buildChartsSection(isDesktop),
                      buildChartsSection1(isDesktop, context),
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
          child: buildLineChart(),
        ),
        Container(
          width: isDesktop
              ? (MediaQuery.of(context).size.width - 64) / 2
              : MediaQuery.of(context).size.width - 32,
          height: 400,
          child: buildPieChart(),
        ),
      ],
    );
  }
}
