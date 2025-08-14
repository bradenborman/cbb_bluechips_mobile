import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool danger;

  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.danger = false,
  });

  const SettingsSection.danger({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  }) : danger = true;

  @override
  Widget build(BuildContext context) {
    final cardColor = danger
        ? Color.lerp(
            Theme.of(context).colorScheme.errorContainer,
            Theme.of(context).colorScheme.surface,
            0.7,
          )
        : Theme.of(context).colorScheme.surface;

    final borderColor = danger
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).dividerColor;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: danger
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurface,
    );

    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (danger) ...[
                  const Icon(Icons.warning_rounded, size: 18),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(title, style: titleStyle)),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
