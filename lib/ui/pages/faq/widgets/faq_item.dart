// lib/pages/faq/widgets/faq_item.dart
import 'package:cbb_bluechips_mobile/models/faq_models.dart';
import 'package:cbb_bluechips_mobile/ui/pages/faq/widgets/faq_tip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqItem extends StatelessWidget {
  final Faq faq;
  const FaqItem({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    final questionStyle = Theme.of(context).textTheme.titleMedium;
    final lineStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(height: 1.35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.help_outline,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(faq.question, style: questionStyle)),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...faq.answer.map((a) => _buildLine(context, a, lineStyle)),
                if (faq.tip != null) ...[
                  const SizedBox(height: 8),
                  FaqTipChip(tip: faq.tip!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildLine(BuildContext context, FaqLine line, TextStyle? style) {
    if (line is FaqTextLine) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(line.text, style: style),
      );
    }
    if (line is FaqLinkLine) {
      final linkColor = Theme.of(context).colorScheme.primary;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: RichText(
          text: TextSpan(
            style: style,
            children: [
              TextSpan(text: line.before),
              TextSpan(
                text: line.linkText,
                style: style?.copyWith(
                  color: linkColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _handleLinkTap(context, line.link),
              ),
              if (line.after.isNotEmpty) TextSpan(text: line.after),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _handleLinkTap(BuildContext context, String link) async {
    // Internal route
    if (link.startsWith('/')) {
      Navigator.of(context).pushNamed(link);
      return;
    }
    // External or mailto
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
