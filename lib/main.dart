// lib/main.dart
import 'package:cbb_bluechips_mobile/ui/pages/about/about_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/account/account_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/faq/faq_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/how_to_play/how_to_play_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/leaderboard/leaderboard_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/settings/settings_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/support/support_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/transactions/transactions_page.dart';
import 'package:flutter/material.dart';

import 'theme.dart';
import 'ui/splash_screen.dart';
import 'ui/app_shell.dart';
import 'ui/section_stub.dart';
import 'ui/auth/login_page.dart';

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
      controller: auth,
      child: CbbBlueChipsApp(auth: auth),
    ),
  );
}

class CbbBlueChipsApp extends StatefulWidget {
  final AuthController auth;
  const CbbBlueChipsApp({super.key, required this.auth});

  @override
  State<CbbBlueChipsApp> createState() => _CbbBlueChipsAppState();
}

class _CbbBlueChipsAppState extends State<CbbBlueChipsApp> {
  AuthController get _auth => widget.auth;

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
        // Shell / Auth
        AppShell.route: (_) => const AppShell(),
        LoginPage.route: (_) => const LoginPage(),

        // Your explicit page routes
        HowToPlayPage.route: (_) => const HowToPlayPage(),
        FAQPage.route: (_) => const FAQPage(),
        AccountPage.route: (_) => const AccountPage(),
        TransactionsPage.route: (_) => const TransactionsPage(),
        SupportPage.route: (_) => const SupportPage(),
        SettingsPage.route: (_) => const SettingsPage(),
        AboutPage.route: (_) => const AboutPage(),
        LeaderboardPage.route: (_) => const LeaderboardPage(),

        // Calculator still using a stub for now
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
      },
    );
  }
}
