//libs/services/auth/auth_gate.dart

import 'package:cbb_bluechips_mobile/ui/app_shell.dart';
import 'package:cbb_bluechips_mobile/ui/auth/login_page.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_controller.dart';

/// Simple scope to access AuthController in the subtree.
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<AuthScope>()
        : context.getElementForInheritedWidgetOfExactType<AuthScope>()?.widget
              as AuthScope?;
    assert(scope != null, 'AuthScope not found. Wrap your app with AuthScope.');
    return scope!.notifier!;
  }
}

class AuthGate extends StatelessWidget {
  final AuthController controller;
  const AuthGate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) =>
            controller.isAuthed ? const AppShell() : const LoginPage(),
      ),
    );
  }
}