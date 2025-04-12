import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/models/Department.dart';
import 'package:meyar/DashBoard/PopUp/employeepopup.dart';

class DepartmentCard extends StatelessWidget {
  final Department dept;
  final bool isDesktop;
  final Department? selectedDepartment;

  const DepartmentCard({
    Key? key,
    required this.dept,
    required this.isDesktop,
    required this.selectedDepartment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
