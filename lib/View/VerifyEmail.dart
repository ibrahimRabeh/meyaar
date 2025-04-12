import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/Colors.dart';
import '../Components/Toast.dart';
import '/Auth/Authservice.dart';
import '/Auth/FireBaseAuth.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool _isSending = false;
  bool _isChecking = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    // Send verification email on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationEmail();
    });
  }

  Future<void> _getUserEmail() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _userEmail = firebaseUser.email;
      });
    }
  }

  void _sendVerificationEmail() async {
    if (_isSending) return;
    setState(() {
      _isSending = true;
    });
    try {
      final authService = Authservice(FirebBaseAuth());
      await authService.SendEmailVerification();
      toast("Verification email sent", color: AppColors.successColor);
    } catch (e) {
      toast("Failed to send verification email: ${e.toString()}",
          color: AppColors.errorColor);
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _checkVerification() async {
    setState(() {
      _isChecking = true;
    });
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        if (currentUser.emailVerified) {
          toast("Email verified!", color: AppColors.successColor);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/ReRouter', (route) => false);
        } else {
          toast("Email not verified yet");
        }
      }
    } catch (e) {
      toast("Failed to check verification: ${e.toString()}",
          color: AppColors.errorColor);
    } finally {
      setState(() {
        _isChecking = false;
      });
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
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth > 600 ? constraints.maxWidth * 0.2 : 32.0;
            final cardWidth = constraints.maxWidth > 600
                ? 500.0
                : constraints.maxWidth - (2 * horizontalPadding);
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Branding Section
                    Column(
                      children: [
                        Icon(
                          Icons.mark_email_read_rounded,
                          size: 72,
                          color: AppColors.secondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Meyar",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Verify Your Email",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                    // Verification Card
                    Container(
                      width: cardWidth,
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
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Check Your Email",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _userEmail != null
                                ? "We've sent a verification email to $_userEmail. Please click the link in the email to verify your account."
                                : "We've sent a verification email. Please check your inbox.",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed:
                                  _isChecking ? null : _checkVerification,
                              child: _isChecking
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : const Text(
                                      "I've Verified My Email",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed:
                                _isSending ? null : _sendVerificationEmail,
                            icon: _isSending
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Icon(
                                    Icons.refresh,
                                    color: AppColors.secondaryColor,
                                  ),
                            label: Text(
                              "Resend Verification Email",
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/Register', (route) => false);
                      },
                      child: Text(
                        "Use a different email address",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
