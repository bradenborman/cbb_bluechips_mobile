import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/trade_service.dart';

class TradeInfoCards extends StatelessWidget {
  final TeamTradeDetailsResponse d;
  final String Function(num) fmt;
  const TradeInfoCards({super.key, required this.d, required this.fmt});

  @override
  Widget build(BuildContext context) {
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
                          Text(fmt(t.amountOwned)),
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
                          Text(fmt(p.price)),
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
}
