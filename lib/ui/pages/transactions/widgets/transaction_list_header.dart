import 'package:flutter/material.dart';

class TransactionListHeader extends StatelessWidget {
  final String playerLabel;
  final String teamLabel;
  final String amountLabel;
  final String dateLabel;

  const TransactionListHeader({
    super.key,
    required this.playerLabel,
    required this.teamLabel,
    required this.amountLabel,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 720) {
        // hide on mobile to match your original design
        return const SizedBox.shrink();
      }
      final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w700,
          );

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x1F000000))),
        ),
        child: Row(
          children: [
            const SizedBox(width: 36), // badge width spacer
            Expanded(flex: 2, child: Text(playerLabel, style: labelStyle)),
            Expanded(flex: 2, child: Text(teamLabel, style: labelStyle)),
            Expanded(flex: 2, child: Text(amountLabel, style: labelStyle)),
            Expanded(flex: 2, child: Text(dateLabel, style: labelStyle)),
          ],
        ),
      );
    });
  }
}
