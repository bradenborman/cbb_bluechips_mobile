import 'package:flutter/material.dart';

class HowToPlaySection extends StatelessWidget {
  const HowToPlaySection({
    super.key,
    required this.title,
    required this.desc,
    required this.children,
  });

  final String title;
  final String desc;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isLg = width >= 1024;

    final titleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: isLg ? 54 : 34,
      height: 1.05,
      color: theme.colorScheme.onSurface,
    );
    final descStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: EdgeInsets.only(left: isLg ? 56 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isLg)
            Positioned(left: -56, top: 8, bottom: -20, child: _VerticalGuide()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(desc, style: descStyle),
              const SizedBox(height: 4),
              Text(title, style: titleStyle),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ],
      ),
    );
  }
}

class HowToPlaySubSection extends StatelessWidget {
  const HowToPlaySubSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final Widget children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_Pill(title), const SizedBox(height: 10), children],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: theme.colorScheme.onSurface.withOpacity(0.08),
    );
  }
}

class Subheading extends StatelessWidget {
  const Subheading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  const Bullet(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.value);
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _VerticalGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guideColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.6)
        : Colors.black.withOpacity(0.2);

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Center(child: Icon(Icons.sports_basketball, size: 18)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              color: guideColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
