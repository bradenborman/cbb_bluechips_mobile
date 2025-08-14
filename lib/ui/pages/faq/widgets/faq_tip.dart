import 'package:cbb_bluechips_mobile/models/faq_models.dart';
import 'package:flutter/material.dart';

class FaqTipChip extends StatelessWidget {
  final FaqTip tip;
  const FaqTipChip({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isInfo = tip.type == FaqTipType.info;
    final bg = isInfo
        ? scheme.primary.withOpacity(0.15)
        : Colors.amber.withOpacity(0.25);
    final border = isInfo
        ? scheme.primary.withOpacity(0.35)
        : Colors.amber.withOpacity(0.45);
    final iconColor = isInfo ? scheme.primary : Colors.amber[800];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isInfo ? Icons.info_outline : Icons.warning_amber_rounded,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip.text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}