import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

Widget buildStatCardsSection(bool isDesktop, Map<String, dynamic> data) {
  return GridView.count(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisCount: isDesktop ? 4 : 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: isDesktop ? 3 : 1.3,
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
                isCurrency ? '\$${value.toStringAsFixed(2)}' : value.toString(),
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
