import 'package:flutter/material.dart';
import '../models.dart';

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

  String _formatPoints(int p) {
    // mirrors your formatPoints
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
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              // Left: #Rank and Username
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
                  const SizedBox(width: 8),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 12),
              // Right: Total Points
              Text(
                _formatPoints(totalPoints),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Player', style: muted),
              Text('Total Points', style: muted),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor.withOpacity(0.6)),
        ],
      ),
    );
  }
}
