import 'package:flutter/material.dart';

class ResetPasswordControllers {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
