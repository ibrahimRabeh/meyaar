import 'package:flutter/material.dart';
import 'package:meyar/util/Colors.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.05),
              AppColors.backgroundColor,
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 40.0 : 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Meyar',
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : 24,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildPortalOptions(context, isDesktop),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortalOptions(BuildContext context, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPortalCard(
                context,
                true,
                Icons.person,
                'Employee Portal',
                'Access your dashboard',
                AppColors.secondaryColor,
                isDesktop,
              ),
              const SizedBox(width: 20),
              _buildPortalCard(
                context,
                false,
                Icons.groups,
                'HR Portal',
                'Manage resources',
                AppColors.accentColor,
                isDesktop,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildPortalCard(
                context,
                true,
                Icons.person,
                'Employee Portal',
                'Access your dashboard',
                AppColors.secondaryColor,
                isDesktop,
              ),
              const SizedBox(height: 20),
              _buildPortalCard(
                context,
                false,
                Icons.groups,
                'HR Portal',
                'Manage resources',
                AppColors.accentColor,
                isDesktop,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPortalCard(
    BuildContext context,
    bool isEmployee,
    IconData icon,
    String title,
    String description,
    Color color,
    bool isDesktop,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          isEmployee ? '/Quiz' : '/dashboard',
        );
      },
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
