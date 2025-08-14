import 'package:cbb_bluechips_mobile/ui/pages/rules/rules_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/faq/faq_page.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'ui/splash_screen.dart';
import 'ui/app_shell.dart';
import 'ui/section_stub.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CbbBlueChipsApp());
}

class CbbBlueChipsApp extends StatelessWidget {
  const CbbBlueChipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBB Blue Chips',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
      routes: {
        AppShell.route: (_) => const AppShell(),
        RulesPage.route: (_) => const RulesPage(),
        FAQPage.route: (_) => const FAQPage(),

        // Stubs
        '/transactions': (_) => const SectionStub(title: 'Transactions'),
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
        '/settings': (_) => const SectionStub(title: 'Settings'),
        '/support': (_) => const SectionStub(title: 'Support'),
        '/about': (_) => const SectionStub(title: 'About'),
      },
    );
  }
}
