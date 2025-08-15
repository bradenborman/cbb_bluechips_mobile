import 'package:flutter/material.dart';

import 'models.dart';
import 'team_buy_sheet.dart';
import 'widgets/match_card.dart';

/// Route so you can do routes['/market'] or Navigator.pushNamed(context, MarketPage.route)
class MarketPage extends StatefulWidget {
  static const route = '/market';
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final _repo = const MarketRepository();
  final _scroll = ScrollController();

  var _status = _LoadStatus.loading;
  var _games = <GameResult>[];
  var _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scroll.position.pixels > 600;
    if (show != _showBackToTop) {
      setState(() => _showBackToTop = show);
    }
  }

  Future<void> _load() async {
    setState(() => _status = _LoadStatus.loading);
    try {
      final data = await _repo.fetchFinals();
      setState(() {
        _games = data;
        _status = _LoadStatus.ready;
      });
    } catch (_) {
      setState(() => _status = _LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          content,
          if (_status == _LoadStatus.loading) const _LoadingOverlay(),
        ],
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () {
                _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                );
              },
              tooltip: 'Back to top',
              child: const Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_status == _LoadStatus.loading) {
      return const SizedBox.expand();
    }

    if (_status == _LoadStatus.error) {
      return const Center(
        child: _LabelAndDescription(
          label: 'Something went wrong',
          desc:
              'Could not load market. Pull to retry or tap the refresh button.',
        ),
      );
    }

    if (_games.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _LabelAndDescription(
            label: 'No matches today!',
            desc: 'Please check back at another time.',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          // No filter chips anymore.
          ..._games.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchCard(
                game: g,
                onTapTeam: (team, ps) => _openBuySheet(team, ps),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _openBuySheet(TeamResult team, double ps) async {
    final qty = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => TeamBuySheet(team: team, pointSpeed: ps),
    );

    if (qty != null && qty > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchased $qty shares of ${team.name}')),
      );
    }
  }
}

enum _LoadStatus { loading, ready, error }

class _LabelAndDescription extends StatelessWidget {
  final String label;
  final String desc;
  const _LabelAndDescription({required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(desc, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Colors.black.withOpacity(0.08),
        child: const Center(child: _WrappedSpinner()),
      ),
    );
  }
}

class _WrappedSpinner extends StatelessWidget {
  const _WrappedSpinner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: const SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}
