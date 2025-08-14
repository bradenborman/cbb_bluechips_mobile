import 'package:flutter/material.dart';
import '../theme.dart';
import 'dotted_background.dart';

class StubPage extends StatelessWidget {
  final String title;
  const StubPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text(
            '$title screen coming soon',
            style: const TextStyle(color: AppColors.ice, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
