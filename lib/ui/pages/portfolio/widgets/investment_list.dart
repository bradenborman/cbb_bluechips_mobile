import 'package:flutter/material.dart';
import '../../../../models/models.dart';

class InvestmentList extends StatelessWidget {
  final List<Investment> items;
  final void Function(Investment)? onTap;

  const InvestmentList({super.key, this.items = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No active investments',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      children: items
          .map((it) => _InvestmentRow(inv: it, onTap: onTap))
          .toList(),
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  final Investment inv;
  final void Function(Investment)? onTap;
  const _InvestmentRow({required this.inv, this.onTap});

  String _fmt(num v) {
    final s = v.toInt().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write(',');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final seedText = inv.seed.isNotEmpty ? ' (${inv.seed})' : '';
    final initials =
        (inv.teamName.length >= 3 ? inv.teamName.substring(0, 3) : inv.teamName)
            .toUpperCase();

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(inv),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${inv.teamName}$seedText',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${inv.amountOwned} shares',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              _fmt(inv.marketPrice),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
