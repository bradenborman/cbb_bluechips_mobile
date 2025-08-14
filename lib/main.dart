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

        '/transactions': (_) => const SectionStub(title: 'Transactions'),
        '/rules': (_) => const SectionStub(title: 'Rules'),
        '/calculator': (_) => const SectionStub(title: 'Calculator'),
        '/faq': (_) => const SectionStub(title: 'FAQ'),
        '/settings': (_) => const SectionStub(title: 'Settings'),
        '/support': (_) => const SectionStub(title: 'Support'),
        '/about': (_) => const SectionStub(title: 'About'),
      },
    );
  }
}
