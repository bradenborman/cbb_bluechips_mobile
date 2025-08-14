import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LegalContactList extends StatelessWidget {
  const LegalContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.bodyMedium;
    final link = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactRow(
          label: 'Email',
          child: GestureDetector(
            onTap: () => launchUrlString('mailto:support@cbbbluechips.com'),
            child: Text('support@cbbbluechips.com', style: link),
          ),
        ),
        const SizedBox(height: 8),
        _ContactRow(
          label: 'Website',
          child: GestureDetector(
            onTap: () => launchUrlString('https://www.cbbbluechips.com'),
            child: Text('https://www.cbbbluechips.com', style: link),
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _ContactRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: labelStyle)),
        Expanded(child: child),
      ],
    );
  }
}