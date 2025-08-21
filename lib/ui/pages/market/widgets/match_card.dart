import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';

import 'date_label.dart';
import 'team_row.dart';
import 'vs_chip.dart';
import 'spread_pill.dart'; // <-- new

class MatchCard extends StatelessWidget {
  final Match match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final started = match.startTime;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: date + status pill
          Row(
            children: [
              Expanded(
                child: DateLabel(
                  dateTime: started,
                  fallback: match.completed ? 'Final' : 'TBD',
                ),
              ),
              _StatusPill(text: match.completed ? 'Completed' : 'Open'),
            ],
          ),
          const SizedBox(height: 12),

          // Home team row
          TeamRow(
            team: match.homeTeam,
            onTap: () => _tapSnack(context, match.homeTeam.teamName),
          ),
          const SizedBox(height: 6),
          SpreadPill(
            teamId: match.homeTeam.teamId,
            favoriteTeamId: match.favoriteTeamId,
            underdogTeamId: match.underdogTeamId,
            pointSpread: match.pointSpread,
          ),

          const SizedBox(height: 10),

          // Centered "VS"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [VsChip()],
          ),

          const SizedBox(height: 10),

          // Away team row
          TeamRow(
            team: match.awayTeam,
            onTap: () => _tapSnack(context, match.awayTeam.teamName),
          ),
          const SizedBox(height: 6),
          SpreadPill(
            teamId: match.awayTeam.teamId,
            favoriteTeamId: match.favoriteTeamId,
            underdogTeamId: match.underdogTeamId,
            pointSpread: match.pointSpread,
          ),
        ],
      ),
    );
  }

  void _tapSnack(BuildContext context, String teamName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buy/Sell for $teamName coming next'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool isCompleted = text.toLowerCase().startsWith('comp');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? cs.tertiaryContainer : cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isCompleted ? cs.onTertiaryContainer : cs.onPrimaryContainer,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
