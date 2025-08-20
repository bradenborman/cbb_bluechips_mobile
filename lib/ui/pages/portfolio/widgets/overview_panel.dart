import 'package:flutter/material.dart';
import '../../../../models/models.dart';

class OverviewPanel extends StatelessWidget {
  final int leaderboardPosition;
  final String username;
  final int totalPoints;
  final RequestStatus status;

  const OverviewPanel({
    super.key,
    required this.leaderboardPosition,
    required this.username,
    required this.totalPoints,
    required this.status,
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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
      // If your toolchain complains about withOpacity, swap to:
      // color: onSurface.withValues(alpha: 0.6),
      color: onSurface.withOpacity(0.6),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          // Left: #Rank and Username
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('#', style: muted),
              const SizedBox(width: 2),
              Text(
                '$leaderboardPosition',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                username,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Right: Total Points (value + label under it)
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
    );
  }
}