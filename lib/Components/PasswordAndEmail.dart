import 'package:flutter/material.dart';
import '../util/Colors.dart';

class PasswordandEmail extends StatefulWidget {
  const PasswordandEmail({super.key});
  @override
  State<PasswordandEmail> createState() => _PasswordandEmailState();

  _PasswordandEmailState() {
    return PasswordandEmailState();
  }
}

class PasswordandEmailState extends State<PasswordandEmail> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String getEmail() {
    return _email.text.trim();
  }

  String getPassword() {
    return _password.text;
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
      labelStyle: TextStyle(color: AppColors.textSecondary),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.secondaryColor)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.secondaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.errorColor,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.errorColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _email,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration(
            labelText: "Email Address",
            hintText: "Enter your email address",
            prefixIcon: Icons.email_outlined,
          ),
          style: TextStyle(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _password,
          obscureText: !_isPasswordVisible,
          decoration: _buildInputDecoration(
            labelText: "Password",
            hintText: "Enter your password",
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
