import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

Widget buildBarChart() {
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
