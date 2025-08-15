import 'package:flutter/material.dart';

class HighlightSpan extends WidgetSpan {
  HighlightSpan(String value, {Key? key})
    : super(
        alignment: PlaceholderAlignment.middle,
        child: _HighlightChip(value: value, key: key),
      );
}

/// Visual chip used by HighlightSpan.
class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.value, super.key});
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
