import 'package:flutter/material.dart';

class VsChip extends StatelessWidget {
  const VsChip({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ), // 4) tighter
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh, // 4) slightly darker
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        'vs',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w900, // 4) bolder
        ),
      ),
    );
  }
}
