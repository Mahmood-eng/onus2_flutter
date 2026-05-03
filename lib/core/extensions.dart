import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

extension SnackBarExtension on BuildContext {
  void showAppSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}
