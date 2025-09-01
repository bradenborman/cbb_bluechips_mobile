import 'package:flutter/material.dart';

class SnapshotCard extends StatelessWidget {
  final int leaderboardPosition;
  final String displayName;
  final int totalPoints;
  final int availablePoints;
  final int investedPoints;

  const SnapshotCard({
    super.key,
    required this.leaderboardPosition,
    required this.displayName,
    required this.totalPoints,
    required this.availablePoints,
    required this.investedPoints,
  });

  String _fmt(int p) {
    final s = p.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onSurface = cs.onSurface;
    final muted = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: onSurface.withValues(alpha: 0.6));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          // Header row: name/rank on left, total points on right
          Row(
            children: [
              // Left side: stacked name + rank
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('#', style: muted),
                      const SizedBox(width: 2),
                      Text(
                        '$leaderboardPosition',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Right side: stacked total value + label
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(totalPoints),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('Total Points', style: muted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),

          // Balances: Available | Invested
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: _BalanceTile(
                    label: 'Available',
                    value: availablePoints,
                    labelColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BalanceTile(
                    label: 'Invested',
                    value: investedPoints,
                    labelColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final String label;
  final int value;
  final Color? labelColor;

  const _BalanceTile({
    required this.label,
    required this.value,
    this.labelColor,
  });

  String _fmt(int p) {
    final s = p.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: labelColor ?? cs.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _fmt(value),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
