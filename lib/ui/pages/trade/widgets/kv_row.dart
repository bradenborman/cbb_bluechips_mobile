import 'package:flutter/material.dart';

class TradeKVRow extends StatelessWidget {
  final String k;
  final String v;
  final bool dimValue;
  const TradeKVRow(this.k, this.v, {super.key, this.dimValue = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
          Text(
            v,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: dimValue
                  ? cs.onSurface.withValues(alpha: 0.75)
                  : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}