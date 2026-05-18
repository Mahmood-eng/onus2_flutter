import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/views/auth/login_screen.dart';
import 'package:onus2_flutter/views/auth/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _isLogin
                ? LoginScreen(onToggle: _toggleMode)
                : SignupScreen(onToggle: _toggleMode),
          ),
        ),
      ),
    );
  }
}
