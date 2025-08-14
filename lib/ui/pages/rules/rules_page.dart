import 'package:flutter/material.dart';

/// CBB Blue Chips – Rules / How To Play
///
/// Drop this page into your routes (e.g., '/rules') and push it from
/// anywhere in the app. The layout mirrors your web components:
/// - HowToPlaySection
/// - HowToPlayStepTitle
/// - HowToPlaySubSection
/// - HowToPlayVerticalGuideline
/// - Highlight + Line
///
/// Notes
/// - Uses Material 3 tokens from ThemeData for dark/light by default
/// - Responsive type scales for title/desc
/// - Guideline only shows on wide screens
/// - Non-breaking with long text
/// - Copy is placeholder – swap with your final rules text
class RulesPage extends StatelessWidget {
  static const route = '/rules';
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('How to Play'), centerTitle: false),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: _RulesBody(),
        ),
      ),
    );
  }
}

class _RulesBody extends StatelessWidget {
  const _RulesBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HowToPlaySection(
          title: 'Draft your Portfolio',
          desc: 'Step 1',
          children: const [
            HowToPlaySubSection(
              title: 'Overview',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bullet('Pick players to build a starting portfolio.'),
                  _Bullet('You can adjust holdings as the market moves.'),
                  _Bullet(
                    'Your goal is to finish the week with the highest portfolio value.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            HowToPlaySubSection(
              title: 'Roster Basics',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Line(),
                  _KeyValue('Initial Bankroll', '10,000 chips'),
                  _KeyValue('Positions', 'Any player listed on the slate'),
                  _KeyValue('Edits Window', 'Up to tip of the first game'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        HowToPlaySection(
          title: 'Price Movement',
          desc: 'Step 2',
          children: const [
            HowToPlaySubSection(
              title: 'How prices change',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bullet(
                    'Player prices adjust based on performance signals and demand.',
                  ),
                  _Bullet('Prices can change intra-day around game times.'),
                  _Bullet(
                    'You can buy or sell between games when windows are open.',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        HowToPlaySection(
          title: 'Scoring & Standings',
          desc: 'Step 3',
          children: const [
            HowToPlaySubSection(
              title: 'Weekly result',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bullet(
                    'Standings are determined by end-of-week portfolio value.',
                  ),
                  _Bullet('Tie goes to closest tiebreaker answer.'),
                ],
              ),
            ),
            SizedBox(height: 12),
            HowToPlaySubSection(
              title: 'Tiebreaker',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Line(),
                  _KeyValue(
                    'Example',
                    'Total points by the featured player in the Sunday game',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        HowToPlaySection(
          title: 'Eligibility & Fair Play',
          desc: 'Step 4',
          children: const [
            HowToPlaySubSection(
              title: 'Basics',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bullet('One account per person.'),
                  _Bullet('Free-to-play for friends and family.'),
                  _Bullet(
                    'Admin may adjust obvious errors or incomplete lineups.',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        HowToPlaySection(
          title: 'Glossary',
          desc: 'Step 5',
          children: const [
            HowToPlaySubSection(
              title: 'Terms',
              children: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _KeyValue('Chips', 'In-game currency used to buy players'),
                  _KeyValue(
                    'Portfolio Value',
                    'Your bankroll plus current value of all holdings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HowToPlaySection extends StatelessWidget {
  const HowToPlaySection({
    super.key,
    required this.title,
    required this.desc,
    this.children,
  });

  final String title;
  final String desc;
  final List<Widget>? children;

  bool get _isWide => _cachedIsWide ?? false;
  static bool? _cachedIsWide; // tiny perf cache per build

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    _cachedIsWide = width >= 1024; // approx lg breakpoint

    final section = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HowToPlayStepTitle(title: title, desc: desc),
        const SizedBox(height: 16),
        if (children != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...children!,
              SizedBox(height: _isWide ? 28 : 16),
            ],
          ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(left: _isWide ? 56 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_isWide)
            const Positioned(
              left: -56,
              top: 8,
              bottom: -20,
              child: HowToPlayVerticalGuideline(),
            ),
          section,
        ],
      ),
    );
  }
}

class HowToPlayStepTitle extends StatelessWidget {
  const HowToPlayStepTitle({
    super.key,
    required this.title,
    required this.desc,
  });
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isXs = width < 380;
    final isLg = width >= 1024;

    final titleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: isLg ? 54 : (isXs ? 26 : 34),
      color: theme.colorScheme.onSurface,
      height: 1.05,
    );
    final descStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: isXs ? 14 : 16,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(desc, style: descStyle),
        const SizedBox(height: 4),
        Text(title, style: titleStyle),
      ],
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
        children: [
          Highlight(value: title),
          const SizedBox(height: 10),
          children,
        ],
      ),
    );
  }
}

class HowToPlayVerticalGuideline extends StatelessWidget {
  const HowToPlayVerticalGuideline({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.6)
                  : Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

/// UI atoms
class Highlight extends StatelessWidget {
  const Highlight({super.key, required this.value});
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

class _Line extends StatelessWidget {
  const _Line();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.onSurface.withOpacity(0.08),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
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

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.keyLabel, this.valueLabel);
  final String keyLabel;
  final String valueLabel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              keyLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Text(
              valueLabel,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
