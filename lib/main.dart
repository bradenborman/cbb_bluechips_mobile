// lib/main.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'ui/splash_screen.dart';
import 'ui/app_shell.dart';
import 'ui/section_stub.dart';

import 'services/auth/auth_controller.dart';
import 'services/auth/auth_repository_api.dart' show AuthRepositoryApi;
import 'services/auth/auth_gate.dart';
import 'services/auth/auth_scope.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ONE controller and use it everywhere
  final auth = AuthController(AuthRepositoryApi());

  runApp(
    AuthScope(
      controller: auth, // <-- TOP-LEVEL SCOPE
      child: CbbBlueChipsApp(auth: auth), // pass it through too
    ),
  );
}

class CbbBlueChipsApp extends StatefulWidget {
  final AuthController auth; // <-- ADD
  const CbbBlueChipsApp({super.key, required this.auth});

  @override
  State<CbbBlueChipsApp> createState() => _CbbBlueChipsAppState();
}

class _CbbBlueChipsAppState extends State<CbbBlueChipsApp> {
  // remove the internal creation, use the one from widget.auth
  AuthController get _auth => widget.auth;

  // Navigator key so we can navigate without a BuildContext tied to a Navigator
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBB Blue Chips',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      navigatorKey: _navKey,
      home: SplashScreen(
        onDone: () {
          _navKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => AuthGate(controller: _auth)),
          );
        },
      ),
      routes: {
        AppShell.route: (_) => const AppShell(),
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
        // ...your other routes...
      },
    );
  }
}