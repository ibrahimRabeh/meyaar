import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';
import 'package:meyar/DashBoard/Department/DepartmentCard.dart';
import 'package:meyar/DashBoard/Department/DepartmentData.dart';

Widget DepartmentSection(bool isDesktop) {
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
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 8,
            childAspectRatio: isDesktop ? 4 : 1.8,
          ),
          itemCount: departmentsData.length,
          itemBuilder: (context, index) {
            final dept = departmentsData[index];
            return DepartmentCard(
              dept: dept,
              key: Key(dept.id.toString()),
              isDesktop: isDesktop,
              selectedDepartment: null,
            );
          },
        ),
      ],
    ),
  );
}
