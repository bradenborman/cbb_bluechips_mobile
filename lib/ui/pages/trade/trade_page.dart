import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';
import 'package:cbb_bluechips_mobile/services/trade_service.dart';

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

      final maxBuy = _computeMaxBuy(d);
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

  int _computeMaxBuy(TeamTradeDetailsResponse d) {
    final price = d.currentMarketPrice.toDouble();
    if (price <= 0) return 0;
    final byCash = (d.purchasingPower / price).floor();
    final byCap = (d.maximumCanPurchase).clamp(0, 1 << 30);
    return byCash < byCap ? byCash : byCap;
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
                _teamCard(context, _d!), // TEAM CARD (name/price/record)
                const SizedBox(height: 16),
                _tradeSection(
                  context,
                  _d!,
                ), // TRADE SECTION (toggle + PP + MaxBuy + slider)
                const SizedBox(height: 20),
                _infoCards(context, _d!), // Shareholders + Prices (no stories)
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

  // ─────────────────────────── TEAM CARD ───────────────────────────
  Widget _teamCard(BuildContext context, TeamTradeDetailsResponse d) {
    final cs = Theme.of(context).colorScheme;
    final seed = (d.seed != null && d.seed!.toString().isNotEmpty)
        ? '(${d.seed}) '
        : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: (Seed) Team Name  |  Current Price
          Row(
            children: [
              Expanded(
                child: Text(
                  '$seed${d.teamName}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(d.currentMarketPrice),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Current Price',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second row: nickname + record
          Row(
            children: [
              if (d.nickname != null && d.nickname!.isNotEmpty)
                Text(
                  d.nickname!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              const Spacer(),
              if (d.teamRecord != null)
                Text(
                  '${d.teamRecord!.wins}-${d.teamRecord!.losses}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────────────── TRADE SECTION ─────────────────────────
  Widget _tradeSection(BuildContext context, TeamTradeDetailsResponse d) {
    final cs = Theme.of(context).colorScheme;

    final maxBuy = _computeMaxBuy(d);
    final disabledByLock =
        (!_isBuyMode && d.amountSharesOwned == 0) ||
        (_isBuyMode && maxBuy == 0) ||
        (_isBuyMode && !d.allowAfterPlayedPurchase && d.locked);

    final cost = _calcCost(d, _qty);
    final label = _isBuyMode ? 'Buy' : 'Sell';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle
          Text(
            'Action',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(value: true, label: Text('Buy')),
              ButtonSegment<bool>(value: false, label: Text('Sell')),
            ],
            selected: {_isBuyMode},
            onSelectionChanged: (sel) {
              final newBuy = sel.first;
              setState(() {
                _isBuyMode = newBuy;
                _maxQty = newBuy ? maxBuy : d.amountSharesOwned;
                _qty = _qty.clamp(0, _maxQty);
              });
            },
          ),

          const SizedBox(height: 16),

          // Purchasing Power + (conditional) Max Can Buy
          _kv(context, 'Purchasing Power', _fmt(d.purchasingPower)),
          if (_isBuyMode) _kv(context, 'Max Can Buy', _fmt(maxBuy)),

          const SizedBox(height: 12),

          // Quantity + Spend/Receive
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quantity: $_qty / $_maxQty',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              Text(
                _isBuyMode ? 'Spend: ${_fmt(cost)}' : 'Receive: ${_fmt(cost)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Slider
          Slider(
            value: _qty.clamp(0, _maxQty).toDouble(),
            min: 0,
            max: (_maxQty > 0 ? _maxQty : 1).toDouble(),
            divisions: _maxQty > 0 ? _maxQty : 1,
            onChanged: disabledByLock
                ? null
                : (v) => setState(() => _qty = v.round().clamp(0, _maxQty)),
          ),

          const SizedBox(height: 8),

          // Place order (stub)
          FilledButton(
            onPressed: (disabledByLock || _qty == 0)
                ? null
                : () {
                    // TODO: Hook to POST buy/sell endpoint
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$label $_qty ${_qty == 1 ? "share" : "shares"} of ${d.teamName} for ${_fmt(cost)}',
                        ),
                      ),
                    );
                  },
            child: Text('$label $_qty ${_qty == 1 ? "Share" : "Shares"}'),
          ),

          if (disabledByLock) ...[
            const SizedBox(height: 8),
            Text(
              'Trading disabled for this team right now.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
          Text(
            v,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ─────────────── Extra info (no stories) ───────────────
  Widget _infoCards(BuildContext context, TeamTradeDetailsResponse d) {
    final cs = Theme.of(context).colorScheme;

    Widget card({required String title, required Widget child}) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

    final top = d.topShareholders.take(5).toList();
    final prices = d.priceHistory.reversed.take(8).toList();

    return Column(
      children: [
        if (top.isNotEmpty)
          card(
            title: 'Top Shareholders',
            child: Column(
              children: top
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(t.fullName)),
                          Text(_fmt(t.amountOwned)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        if (prices.isNotEmpty)
          card(
            title: 'Recent Prices',
            child: Column(
              children: prices
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(child: Text('Round ${p.roundId}')),
                          Text(_fmt(p.price)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
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
