import 'package:flutter/material.dart';
import '/Auth/Authservice.dart';
import '/Auth/FireBaseAuth.dart';
import '../util/Colors.dart';

class ReRouter extends StatefulWidget {
  const ReRouter({super.key});

  @override
  _ReRouterState createState() => _ReRouterState();
}

class _ReRouterState extends State<ReRouter> {
  late final Authservice authService;
  String _status = "Checking authentication...";
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Initialize AuthService once and reuse it
    authService = Authservice(FirebBaseAuth());
    _redirectBasedOnAuthState();
  }

  void _redirectBasedOnAuthState() async {
    try {
      setState(() {
        _status = "Initializing...";
      });

      // Initialize Firebase
      await authService.init();

      setState(() {
        _status = "Checking user status...";
      });

      // Reload user state
      await authService.reload();

      // Add a small delay for better UX
      await Future.delayed(const Duration(milliseconds: 800));

      // Check current user and navigate accordingly
      final currentUser = authService.currentUser;

      if (currentUser == null) {
        setState(() {
          _status = "Not logged in. Redirecting to login...";
        });
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateTo('/Login');
      } else if (currentUser.isEmailVerified) {
        setState(() {
          _status = "Welcome back! Preparing your dashboard...";
        });
        await Future.delayed(const Duration(milliseconds: 800));

        // Check user role to determine redirection
        final bool isEmployee = await _checkIfUserIsEmployee();

        if (isEmployee) {
          _navigateTo('/portal'); // Navigate to Employee Portal
        } else {
          _navigateTo('/portal'); // Navigate to HR Portal
        }
      } else {
        setState(() {
          _status = "Email verification required...";
        });
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateTo('/VerifyEmail');
      }
    } catch (e) {
      // Handle errors and navigate to Login as fallback
      setState(() {
        _status = "Something went wrong: ${e.toString()}";
        _isError = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      _navigateTo('/Login');
    }
  }

  // This function would normally check the Firestore database
  // to determine if the user is an employee or HR personnel
  Future<bool> _checkIfUserIsEmployee() async {
    // For now, return true (employee) by default
    // This should be replaced with actual role check logic
    return true;
  }

  void _navigateTo(String routeName) {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.psychology,
                size: 64,
                color: AppColors.secondaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                "Meyar",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                color:
                    _isError ? AppColors.errorColor : AppColors.secondaryColor,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isError
                        ? AppColors.errorColor
                        : AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
