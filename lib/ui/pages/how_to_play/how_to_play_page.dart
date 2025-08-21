import 'package:flutter/material.dart';

class HowToPlayPage extends StatelessWidget {
  static const route = '/how-to-play';
  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to Play')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Overview',
            paragraphs: const [
              'CBB Blue Chips is a free‑to‑play market game for college basketball. You build net worth by owning shares of teams.',
              'Share values only update after games based on how each team performs relative to the point spread. The game is playable during the regular season and the March tournament.',
            ],
          ),
          _SectionCard(
            title: 'Objective',
            paragraphs: const [
              'Maximize portfolio net worth by holding teams that beat the spread.',
              'The more shares you hold in teams that outperform, the more your portfolio grows.',
            ],
          ),
          _SectionCard(
            title: 'Market Windows',
            paragraphs: const [
              'You may buy and sell at any time except when a team is actively playing.',
              'Trading for that team locks at tip‑off and reopens after the game posts and prices are updated.',
            ],
          ),
          _SectionCard(
            title: 'Getting Started',
            paragraphs: const [
              'New players begin with an initial bankroll (e.g., 100,000 points).',
              'Use your bankroll to buy shares of any team on the slate. Adjust positions as new games approach and results post.',
            ],
          ),
          _SectionCard(
            title: 'How Prices Move',
            paragraphs: const [
              'Prices do not change during games. They update only after the game is final.',
              'Updates are driven by the margin versus the point spread (adjusted score), not just by who won or lost.',
              'Beating the spread increases price; failing to beat it decreases price. Early points above/below the spread have a larger effect, and decreases are typically gentler than increases.',
            ],
            children: const [
              SizedBox(height: 8),
              _InsetNote(
                title: 'Typical Baseline (example)',
                lines: [
                  'Starting share value: 3,000.',
                  'Modest beat of the spread → price ~3,540.',
                  'Modest miss vs the spread → price ~2,840.',
                ],
              ),
            ],
          ),
          _SectionCard(
            title: 'Understanding the Point Spread',
            paragraphs: const [
              'For CBB Blue Chips, each game uses a fixed spread for the day to compute adjusted scores.',
              'Adjusted = Favorite Score − Spread; Underdog Score + Spread. Price movement is determined by which adjusted score is higher and by how much.',
            ],
            children: const [
              SizedBox(height: 8),
              _ExampleCard(
                title: 'Example',
                rows: [
                  ['Spread', '±6.5 (Team A is favorite)'],
                  ['Final Score', 'Team A 76 — Team B 72'],
                  ['Adjusted', 'Team A 76 − 6.5 = 69.5; Team B = 72'],
                  ['Result', 'Adjusted winner: Team B (underdog)'],
                  ['Impact', 'Team A price decreases; Team B price increases'],
                ],
              ),
            ],
          ),
          _SectionCard(
            title: 'Calculating Price Changes',
            paragraphs: const [
              'Price deltas scale with how far the team finished relative to the spread (not simply win/loss).',
              'Use the Calculator to preview exact changes by margin before you trade.',
            ],
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Open Calculator'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/calculator'),
                ),
              ),
            ],
          ),
          _SectionCard(
            title: 'Tips',
            bullets: const [
              'Diversify—avoid going all‑in on a single matchup.',
              'Watch the daily spread; it’s fixed for pricing on that game.',
              'Size positions based on your edge vs the spread, not moneyline.',
              'Rebalance between games when windows reopen.',
            ],
          ),
          const SizedBox(height: 12),
          const _FooterNote(
            text:
                'Fair play: one account per person. Administrators may correct obvious errors or incomplete lineups.',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/* ---------- Local UI helpers (kept simple, const‑friendly) ---------- */

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.paragraphs,
    this.bullets,
    this.children,
  });

  final String title;
  final List<String>? paragraphs; // plain paragraphs
  final List<String>? bullets; // bullet list
  final List<Widget>? children; // optional extra widgets (examples, buttons)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            if (paragraphs != null)
              ...paragraphs!.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    t,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
              ),
            if (bullets != null) ...[
              const SizedBox(height: 4),
              ...bullets!.map((b) => _Bullet(text: b)),
            ],
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
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
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsetNote extends StatelessWidget {
  const _InsetNote({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surfaceContainerHighest;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(height: 1.45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...lines.map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $l'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.title, required this.rows});

  final String title;
  final List<List<String>> rows; // [label, value]

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      r.first,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 8,
                    child: Text(r.last, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.65),
      ),
    );
  }
}
