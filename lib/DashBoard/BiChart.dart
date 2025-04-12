import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/Items/LegendItem.dart';

Widget buildPieChart() {
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
              LegendItem('Senior Level', AppColors.primaryColor),
              LegendItem('Mid Level', AppColors.secondaryColor),
              LegendItem('Junior Level', AppColors.accentColor),
            ],
          ),
        ],
      ),
    ),
  );
}
