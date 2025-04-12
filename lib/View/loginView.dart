import 'package:flutter/material.dart';
import '/Auth/Authservice.dart';
import '/Auth/FireBaseAuth.dart';
import '../util/Colors.dart';
import '../Components/PasswordAndEmail.dart';
import '/Auth/auth_exceptions.dart';
import '../Components/Toast.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<LoginView> {
  final GlobalKey<PasswordandEmailState> _passwordAndEmailKey =
      GlobalKey<PasswordandEmailState>();
  bool _isLoading = false;

  void _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final email = _passwordAndEmailKey.currentState!.getEmail();
      final password = _passwordAndEmailKey.currentState!.getPassword();

      if (email.isEmpty || password.isEmpty) {
        toast("Please enter email and password");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (password.length < 6) {
        toast("Password should be at least 6 characters");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Authservice authservice = Authservice(FirebBaseAuth());
      await authservice.LogIn(email: email, password: password);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/ReRouter', (route) => false);
    } on AuthExceptions catch (e) {
      toast(e.toString());
    } catch (e) {
      toast(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
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
                          Icons.psychology,
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
                          "Knowledge Assessment Platform",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                    // Sign In Card
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
                            "Sign In",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Access your account",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          PasswordandEmail(key: _passwordAndEmailKey),
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
                              onPressed: _isLoading ? null : _signIn,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/Register', (route) => false);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
