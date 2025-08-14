import 'package:cbb_bluechips_mobile/ui/pages/about/about_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/account/account_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/rules/rules_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/faq/faq_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/settings/settings_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/support/support_page.dart';
import 'package:cbb_bluechips_mobile/ui/pages/transactions/transactions_page.dart';
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
      title: 'CBB BlueChips',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
      routes: {
        AppShell.route: (_) => const AppShell(),
        RulesPage.route: (_) => const RulesPage(),
        FAQPage.route: (_) => const FAQPage(),
        AccountPage.route: (_) => const AccountPage(),
        TransactionsPage.route: (_) => const TransactionsPage(),
        SupportPage.route: (_) => const SupportPage(),
        SettingsPage.route: (_) => const SettingsPage(),
        AboutPage.route: (_) => const AboutPage(),
        
        // Stubs
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
      },
    );
  }
}
