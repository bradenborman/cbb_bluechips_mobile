import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';
import 'package:cbb_bluechips_mobile/services/market/market_service.dart';

// widgets
import 'widgets/widgets.dart';

class MarketPage extends StatefulWidget {
  static const route = '/market';
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

enum _LoadStatus { loading, ready, error }

class _MarketPageState extends State<MarketPage> {
  final _service = const MarketService();
  var _status = _LoadStatus.loading;
  var _matches = <Match>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = _LoadStatus.loading);
    try {
      final res = await _service.getMarket();
      setState(() {
        _matches = res.matches;
        _status = _LoadStatus.ready;
      });
    } catch (_) {
      setState(() => _status = _LoadStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget body;
    switch (_status) {
      case _LoadStatus.loading:
        body = const Center(child: CircularProgressIndicator());
        break;
      case _LoadStatus.error:
        body = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load games'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
        break;
      case _LoadStatus.ready:
        if (_matches.isEmpty) {
          body = const Center(child: Text('No games to show'));
        } else {
          body = RefreshIndicator(
            onRefresh: _load,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: _matches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => MatchCard(match: _matches[i]),
            ),
          );
        }
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Matchups'), centerTitle: false),
      backgroundColor: cs.surface,
      body: body,
    );
  }
}
