// lib/ui/pages/market/widgets/price_pill.dart
import 'package:flutter/material.dart';

class PricePill extends StatelessWidget {
  final double? value;
  const PricePill({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        value == null ? '-' : _moneyInt(value!),
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Always format as whole dollars with commas, e.g. $7,282
String _moneyInt(double v) {
  final whole = v.toInt().toString(); // truncate to integer dollars
  final withCommas = whole.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return withCommas;
}
