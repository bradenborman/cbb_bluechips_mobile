import 'package:flutter/material.dart';

class PredictionVoteList extends StatelessWidget {
  const PredictionVoteList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _PredictionRow(
        question: 'Will Mark Mitchell Score more than 14.5 points?',
        staked: 1500,
        side: 'Yes',
      ),
      _PredictionRow(
        question: 'Will Tom have 3+ rebounds',
        staked: 800,
        side: 'No',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prediction Votes',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}

class _PredictionRow extends StatelessWidget {
  final String question;
  final int staked;
  final String side;
  const _PredictionRow({
    required this.question,
    required this.staked,
    required this.side,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg = Theme.of(context).colorScheme.primary.withOpacity(0.1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(question)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              side,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$staked pts',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
