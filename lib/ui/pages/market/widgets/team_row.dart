import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';

import 'price_pill.dart';

class TeamRow extends StatelessWidget {
  final Team team;
  final VoidCallback? onTap; // 6) tap affordance
  const TeamRow({super.key, required this.team, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final seed = (team.seed ?? '').trim();
    final record = team.teamRecord != null
        ? ' (${team.teamRecord!.wins}-${team.teamRecord!.losses})'
        : '';
    final name = '${team.teamName}$record';

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            // 3) small seed badge before name (if present)
            if (seed.isNotEmpty) ...[
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surface, // neutral dot
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Text(
                  seed,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // name + record
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(width: 12),

            // price
            PricePill(value: team.currentMarketPrice), // 2) formatted inside
          ],
        ),
      ),
    );
  }
}
