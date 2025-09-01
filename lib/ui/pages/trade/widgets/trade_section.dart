import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/trade_service.dart';
import 'kv_row.dart';

class TradeSection extends StatelessWidget {
  final TeamTradeDetailsResponse d;
  final bool isBuyMode;
  final int qty;
  final int maxQty;
  final int maxBuy; // precomputed by parent using price & rules
  final String Function(num) fmt;

  final ValueChanged<bool> onModeChanged;
  final ValueChanged<int> onQtyChanged;

  const TradeSection({
    super.key,
    required this.d,
    required this.isBuyMode,
    required this.qty,
    required this.maxQty,
    required this.maxBuy,
    required this.fmt,
    required this.onModeChanged,
    required this.onQtyChanged,
  });

  num _calcCost(int q) => d.currentMarketPrice * q;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final disabledByLock =
        (!isBuyMode && d.amountSharesOwned == 0) ||
        (isBuyMode && maxBuy == 0) ||
        (isBuyMode && !d.allowAfterPlayedPurchase && d.locked);

    final cost = _calcCost(qty);
    final label = isBuyMode ? 'Buy' : 'Sell';

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
            selected: {isBuyMode},
            onSelectionChanged: (sel) => onModeChanged(sel.first),
          ),

          const SizedBox(height: 16),

          // Purchasing Power + (conditional) Max Can Buy
          TradeKVRow(
            'Purchasing Power',
            fmt(d.purchasingPower),
            dimValue: true,
          ),
          if (isBuyMode) TradeKVRow('Max Can Buy', fmt(maxBuy), dimValue: true),

          const SizedBox(height: 12),

          // Quantity + Spend/Receive
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quantity: $qty / $maxQty',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              Text(
                isBuyMode ? 'Spend: ${fmt(cost)}' : 'Receive: ${fmt(cost)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Material slider with integer divisions
          Slider(
            value: qty.clamp(0, maxQty).toDouble(),
            min: 0,
            max: (maxQty > 0 ? maxQty : 1).toDouble(),
            divisions: maxQty > 0 ? maxQty : 1,
            onChanged: disabledByLock
                ? null
                : (v) => onQtyChanged(v.round().clamp(0, maxQty)),
          ),

          const SizedBox(height: 8),

          // Place order (still a stub; parent can swap later)
          FilledButton(
            onPressed: (disabledByLock || qty == 0)
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$label $qty ${qty == 1 ? "share" : "shares"} of ${d.teamName} for ${fmt(cost)}',
                        ),
                      ),
                    );
                  },
            child: Text('$label $qty ${qty == 1 ? "Share" : "Shares"}'),
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
}