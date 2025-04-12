import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meyar/DashBoard/Charts/BarChart.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/Charts/HexaRadarChartClass.dart';
import 'package:meyar/DashBoard/Items/LegendItem.dart';

Widget buildChartsSection1(bool isDesktop, BuildContext context) {
  return Wrap(
    spacing: 16,
    runSpacing: 16,
    children: [
      Container(
        width: isDesktop
            ? (MediaQuery.of(context).size.width - 64) / 2
            : MediaQuery.of(context).size.width - 32,
        height: 400,
        child: buildBarChart(),
      ),
      Container(
        width: isDesktop
            ? (MediaQuery.of(context).size.width - 64) / 2
            : MediaQuery.of(context).size.width - 32,
        height: 400,
        child: buildRadarChart(),
      ),
    ],
  );
}

Widget buildLineChart() {
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
              LegendItem('Skill Gaps', AppColors.errorColor),
              SizedBox(width: 16),
              LegendItem('Completion Rate', AppColors.secondaryColor),
              SizedBox(width: 16),
              LegendItem('Test Scores', AppColors.successColor),
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

Widget buildRadarChart() {
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
