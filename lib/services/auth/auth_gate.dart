// lib/services/auth/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/ui/app_shell.dart';
import 'package:cbb_bluechips_mobile/ui/auth/login_page.dart';

import 'auth_controller.dart';

class AuthGate extends StatelessWidget {
  final AuthController controller;
  const AuthGate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // AuthScope is already provided at the top of the app (main.dart).
    // We only decide which screen to show based on auth state.
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) =>
          controller.isAuthed ? const AppShell() : const LoginPage(),
    );
  }
  
}