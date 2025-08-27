import 'package:flutter/widgets.dart';
import 'auth_controller.dart';

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
    assert(scope != null, 'AuthScope not found in widget tree');
    return scope!.notifier!;
  }
}