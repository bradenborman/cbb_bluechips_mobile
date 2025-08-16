import 'package:cbb_bluechips_mobile/services/auth/auth_gate.dart';
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

import 'services/auth/auth_repository_mock.dart';
import 'services/auth/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CbbBlueChipsApp());
}

class CbbBlueChipsApp extends StatefulWidget {
  const CbbBlueChipsApp({super.key});

  @override
  State<CbbBlueChipsApp> createState() => _CbbBlueChipsAppState();
}

class _CbbBlueChipsAppState extends State<CbbBlueChipsApp> {
  // Mock auth controller (no init/persistence in this version)
  late final AuthController _auth = AuthController(AuthRepositoryMock());

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
          // No _auth.init() in this mock — just go to the AuthGate
          _navKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => AuthGate(controller: _auth)),
          );
        },
      ),
      routes: {
        AppShell.route: (_) => const AppShell(),
        HowToPlayPage.route: (_) => const HowToPlayPage(),
        FAQPage.route: (_) => const FAQPage(),
        AccountPage.route: (_) => const AccountPage(),
        TransactionsPage.route: (_) => const TransactionsPage(),
        SupportPage.route: (_) => const SupportPage(),
        SettingsPage.route: (_) => const SettingsPage(),
        AboutPage.route: (_) => const AboutPage(),
        LeaderboardPage.route: (_) => const LeaderboardPage(),
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
      },
    );
  }
}