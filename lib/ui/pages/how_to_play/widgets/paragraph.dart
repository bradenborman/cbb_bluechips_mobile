import 'package:flutter/material.dart';

/// A single paragraph with sensible spacing.
/// Use [Paragraph.text] for plain strings, or [Paragraph.spans] for mixed inline styles.
class Paragraph extends StatelessWidget {
  const Paragraph._(this.inlineSpans, {super.key})
    : text = null,
      big = false; // ✅ ensure initialized

  const Paragraph.text(this.text, {super.key})
    : inlineSpans = null,
      big = false; // ✅ ensure initialized

  const Paragraph.spans(this.inlineSpans, {this.big = false, super.key})
    : text = null;

  final String? text;
  final List<InlineSpan>? inlineSpans;
  final bool big; // for big one-liners like "But wait."

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = big
        ? theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          )
        : theme.textTheme.bodyMedium?.copyWith(height: 1.4);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: inlineSpans == null
          ? Text(text ?? '', style: style)
          : RichText(
              text: TextSpan(style: style, children: inlineSpans),
            ),
    );
  }

  /// Convenience link paragraph: plain-leading + tappable link + plain trailing.
  factory Paragraph.link({
    required String leadingText,
    required String linkText,
    required String routeName,
    String trailingText = '',
    Key? key,
  }) {
    return Paragraph._([
      TextSpan(text: leadingText),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: _LinkText(linkText: linkText, routeName: routeName),
      ),
      if (trailingText.isNotEmpty) TextSpan(text: ' $trailingText'),
    ], key: key);
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({required this.linkText, required this.routeName});

  final String linkText;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Text(
        linkText,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
          height: 1.4,
        ),
      ),
    );
  }
}
