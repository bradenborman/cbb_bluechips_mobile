import 'package:flutter/material.dart';
import '../theme.dart';
import 'dotted_background.dart';
import 'section_stub.dart';

class AppShell extends StatefulWidget {
  static const route = '/app';
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static final _pages = <Widget>[
    const SectionStub(title: 'Portfolio'),
    const SectionStub(title: 'Market'),
    const SectionStub(title: 'Prop Bets'),
    const SectionStub(title: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Image.asset(
            'assets/images/cbb-blue-chips-nav-logo.png',
            height: 26,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              tooltip: 'More',
              onPressed: _openMore,
              icon: const Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(index: _index, children: _pages),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.pie_chart),
              label: 'Portfolio',
            ),
            NavigationDestination(
              icon: Icon(Icons.show_chart),
              label: 'Market',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_basketball),
              label: 'Props',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }

  void _openMore() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final items = <_MoreItem>[
          _MoreItem('Transactions', Icons.receipt_long, '/transactions'),
          _MoreItem('Rules', Icons.menu_book, '/rules'),
          _MoreItem('Calculator', Icons.calculate, '/calculator'),
          _MoreItem('FAQ', Icons.help_center, '/faq'),
          _MoreItem('Settings', Icons.settings, '/settings'),
          _MoreItem('Support', Icons.support_agent, '/support'),
          _MoreItem('About', Icons.info, '/about'),
        ];

        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final it = items[i];
              return ListTile(
                leading: Icon(it.icon, color: AppColors.ice),
                title: Text(it.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, it.route);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _MoreItem {
  final String title;
  final IconData icon;
  final String route;
  _MoreItem(this.title, this.icon, this.route);
}
