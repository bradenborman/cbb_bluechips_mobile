// lib/ui/pages/trade/trade_page.dart
import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';
import 'package:cbb_bluechips_mobile/services/trade_service.dart';

// split widgets
import 'widgets/team_card.dart';
import 'widgets/trade_section.dart';
import 'widgets/info_cards.dart';

class TradePage extends StatefulWidget {
  static const route = '/trade';
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final _svc = const TradeService();

  late final String _teamIdArg; // only for request; never display
  late bool _isBuyMode;

  bool _loading = true;
  bool _submitting = false;
  String? _error;
  TeamTradeDetailsResponse? _d;

  // slider state
  int _qty = 0;
  int _maxQty = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    String? from;
    dynamic teamId;

    if (args is Map) {
      teamId = args['teamId'];
      from = args['from'] as String?;
    }
    _teamIdArg = (teamId ?? '').toString();
    _isBuyMode = (from == 'portfolio') ? false : true;

    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userId = AuthScope.of(context, listen: false).currentUser?.userId;
      if (userId == null || userId.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Missing user';
        });
        return;
      }

      final d = await _svc.getTradeDetails(userId: userId, teamId: _teamIdArg);

      // Use API-provided maximumCanPurchase directly (treat negatives as 0 defensively)
      final maxBuy = d.maximumCanPurchase < 0 ? 0 : d.maximumCanPurchase;
      final maxSell = d.amountSharesOwned;
      final max = _isBuyMode ? maxBuy : maxSell;

      setState(() {
        _d = d;
        _maxQty = max.clamp(0, 1000000);
        _qty = 0;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  num _calcCost(TeamTradeDetailsResponse d, int qty) {
    return d.currentMarketPrice * qty;
  }

  String _fmt(num v) {
    final s = v.toInt().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write(',');
    }
    return b.toString();
  }

  Future<void> _handleConfirm(int qty, bool isBuy) async {
    if (_d == null) return;
    final userId = AuthScope.of(context, listen: false).currentUser?.userId;
    if (userId == null || userId.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final updated = isBuy
          ? await _svc.buy(userId: userId, teamId: _teamIdArg, volume: qty)
          : await _svc.sell(userId: userId, teamId: _teamIdArg, volume: qty);

      // Recompute max directly from fresh API values
      final maxBuy = updated.maximumCanPurchase < 0
          ? 0
          : updated.maximumCanPurchase;
      final maxSell = updated.amountSharesOwned;
      final newMax = _isBuyMode ? maxBuy : maxSell;

      setState(() {
        _d = updated;
        _maxQty = newMax.clamp(0, 1000000);
        _qty = 0; // reset slider after a successful trade
      });

      final verb = isBuy ? 'Bought' : 'Sold';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$verb $qty @ ${_fmt(_d!.currentMarketPrice)}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Trade failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Trade'), centerTitle: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_loading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(color: cs.primary),
                  ),
                )
              else if (_error != null)
                _errorBlock(context, _error!)
              else if (_d != null) ...[
                // TEAM CARD (name/seed/price/record)
                TradeTeamCard(d: _d!, fmt: _fmt),

                const SizedBox(height: 16),

                // TRADE SECTION (toggle + PP + MaxBuy + slider)
                TradeSection(
                  d: _d!,
                  isBuyMode: _isBuyMode,
                  qty: _qty,
                  maxQty: _maxQty,
                  maxBuy: _d!.maximumCanPurchase < 0
                      ? 0
                      : _d!.maximumCanPurchase,
                  fmt: _fmt,
                  isBusy: _submitting,
                  onConfirm: _handleConfirm,
                  onModeChanged: (newBuy) {
                    final maxBuy = _d!.maximumCanPurchase < 0
                        ? 0
                        : _d!.maximumCanPurchase;
                    setState(() {
                      _isBuyMode = newBuy;
                      _maxQty = newBuy ? maxBuy : _d!.amountSharesOwned;
                      _qty = _qty.clamp(0, _maxQty);
                    });
                  },
                  onQtyChanged: (q) =>
                      setState(() => _qty = q.clamp(0, _maxQty)),
                ),

                const SizedBox(height: 20),

                // Shareholders + Prices (no stories)
                TradeInfoCards(d: _d!, fmt: _fmt),
              ],

              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Portfolio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────── Misc ───────────────────────────
  Widget _errorBlock(BuildContext context, String msg) {
    return Row(
      children: [
        const Icon(Icons.error_outline),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ],
    );
  }
}