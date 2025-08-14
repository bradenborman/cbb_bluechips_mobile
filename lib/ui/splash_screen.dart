import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'dotted_background.dart';
import 'app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/cbb-blue-chips-brand-logo.png'),
        context,
      );
    });

    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppShell.route);
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: AnimatedBuilder(
            animation: _ctl,
            builder: (context, _) {
              final t = Curves.easeInOut.transform(_ctl.value);
              final scale = 0.97 + 0.06 * t;
              final blur = 24.0 + 8.0 * t;

              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: blur,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: scale,
                    child: Image.asset(
                      'assets/images/cbb-blue-chips-brand-logo.png',
                      width: 180,
                      height: 180,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
