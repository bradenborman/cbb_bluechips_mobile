import 'package:flutter/material.dart';
import '../theme.dart';
import 'dotted_background.dart';

class HomePage extends StatelessWidget {
  static const route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Image.asset(
            'assets/images/cbb-blue-chips-nav-logo.png',
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: const [
              _NavCard(title: 'Portfolio', route: '/portfolio'),
              _NavCard(title: 'Transactions', route: '/transactions'),
              _NavCard(title: 'Market', route: '/market'),
              _NavCard(title: 'Rules', route: '/rules'),
              _NavCard(title: 'Calculator', route: '/calculator'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String route;
  const _NavCard({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, route),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Open',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.ice,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
