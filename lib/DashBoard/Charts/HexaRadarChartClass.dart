import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/Charts/HexaGridPainter.dart';
import 'package:meyar/DashBoard/Charts/HexaRadarPainter.dart';

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
