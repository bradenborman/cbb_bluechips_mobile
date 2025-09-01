import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/trade_service.dart';

class TradeTeamCard extends StatelessWidget {
  final TeamTradeDetailsResponse d;
  final String Function(num) fmt;
  const TradeTeamCard({super.key, required this.d, required this.fmt});

  @override
  Widget build(BuildContext context) {
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
          // (Seed) Team Name  |  Current Price
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
                    fmt(d.currentMarketPrice),
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
          // Nickname (left) + Record (right)
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
}