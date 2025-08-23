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
          // Intro
          _SectionCard(
            title: 'Welcome',
            paragraphs: const [
              'CBB Blue Chips is a free-to-play fantasy sports game built around college basketball’s biggest tournament.',
              'Instead of a single bracket that dies when you miss a pick, you can buy and sell shares of teams all tournament long.',
            ],
          ),
          _SectionCard(
            title: 'The Problem',
            paragraphs: const [
              'Traditional brackets give you one chance to pick the champion. Miss early and you are effectively done.',
            ],
          ),
          _SectionCard(
            title: 'Our Solution',
            paragraphs: const [
              'A flexible market where you can change your mind as often as you like. Pick and choose teams throughout the event.',
            ],
          ),

          // Getting started
          _SectionCard(
            title: 'Part One - Getting Started',
            paragraphs: const [
              'Upon signing up, you receive 100,000 fantasy points.',
              'Use these points to buy and sell fantasy shares of teams whenever you like, except while those teams are actively playing.',
              'Your goal is to invest in teams you believe will perform well to grow your total points.',
            ],
          ),

          // Investing rules
          _SectionCard(
            title: 'Part Two - Investing',
            paragraphs: const [
              'Share values do not fluctuate during play. They only change after a game is completed.',
              'How much they change depends entirely on performance in that game.',
              'Each team starts at a baseline price. Example: 3,000.',
              'If the team outscores its opponent relative to the spread, price rises. Example: around 3,540.',
              'If they fail to do so, price falls. Example: around 2,840.',
            ],
          ),

          // Market windows
          _SectionCard(
            title: 'Market Windows',
            paragraphs: const [
              'You can trade at any time except when a team is actively playing.',
              'Trading for that team locks at tipoff and reopens once the game is final and prices are updated.',
            ],
          ),

          // Spread basics
          _SectionCard(
            title: 'Part Three - The Point Spread',
            paragraphs: const [
              'Blue Chips uses a single fixed spread per game set at the start of the day.',
              'Adjusted scores are used to determine price movement: compare Favorite Score minus Spread to Underdog Score plus Spread.',
            ],
            children: [
              const SizedBox(height: 8),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('What is a spread? Two quick scenarios'),
                children: const [
                  SizedBox(height: 8),
                  _ExampleCard(
                    title: 'Scenario One - Large mismatch',
                    rows: [
                      ['Setup', 'Team A is significantly better than Team B'],
                      ['Spread', '±19 (Team A favored)'],
                      [
                        'Effect',
                        'Team A’s score is effectively reduced by 19 for adjusted comparison',
                      ],
                    ],
                  ),
                  SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Scenario Two - Tight matchup',
                    rows: [
                      ['Setup', 'Team A and Team B are closely matched'],
                      ['Spread', '±2 (Team A favored)'],
                      ['Effect', 'Team A’s adjusted score is reduced by 2'],
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
              const SizedBox(height: 8),
              const _ExampleCard(
                title: 'Worked Example',
                rows: [
                  ['Spread', '±6.5 (Team A favored)'],
                  ['Final Score', 'Team A 76 vs Team B 72'],
                  ['Adjusted', 'Team A: 76 - 6.5 = 69.5; Team B: 72'],
                  ['Adjusted Winner', 'Team B (underdog)'],
                  ['Impact', 'Team A price decreases; Team B price increases'],
                ],
              ),
            ],
          ),

          // Determining share values
          _SectionCard(
            title: 'Part Four - Determining Share Values',
            paragraphs: const [
              'The key question is not simply whether the team beat the spread, but by how many points they were above or below it.',
              'The first few points above or below the spread have a larger impact than later points.',
              'Decreases are only half as severe as increases.',
            ],
            children: [
              const SizedBox(height: 8),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                initiallyExpanded: false,
                title: const Text('Full Value Ladder - Favorite (Team A)'),
                children: const [
                  SizedBox(height: 8),
                  _LadderList(
                    rows: [
                      ['0.5 pts', '2,920'],
                      ['1.5 pts', '2,840'],
                      ['2.5 pts', '2,760'],
                      ['3.5 pts', '2,680'],
                      ['4.5 pts', '2,640'],
                      ['5.5 pts', '2,600'],
                      ['6.5 pts', '2,560'],
                      ['7.5 pts', '2,540'],
                      ['8.5 pts', '2,520'],
                      ['9.5 pts', '2,500'],
                      ['10.5 pts', '2,490'],
                      ['11.5 pts', '2,480'],
                      ['12.5 pts', '2,470'],
                      ['13.5 pts', '2,460'],
                      ['14.5 pts', '2,450'],
                      ['15.5 pts', '2,440'],
                      ['16.5 pts', '2,430'],
                      ['17.5 pts', '2,420'],
                      ['18.5 pts', '2,410'],
                      ['19.5 pts', '2,400'],
                      ['20.5 pts', '2,390'],
                      ['21.5 pts', '2,380'],
                      ['22.5 pts', '2,370'],
                      ['23.5 pts', '2,360'],
                      ['24.5 pts', '2,350'],
                      ['25.5 pts', '2,340'],
                      ['26.5 pts', '2,330'],
                      ['27.5 pts', '2,320'],
                      ['28.5 pts', '2,310'],
                      ['29.5 pts', '2,300'],
                      ['30.5 pts', '2,290'],
                      ['31.5 pts', '2,280'],
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                initiallyExpanded: false,
                title: const Text('Full Value Ladder - Underdog (Team B)'),
                children: const [
                  SizedBox(height: 8),
                  _LadderList(
                    rows: [
                      ['0.5 pts', '3,160'],
                      ['1.5 pts', '3,320'],
                      ['2.5 pts', '3,480'],
                      ['3.5 pts', '3,640'],
                      ['4.5 pts', '3,720'],
                      ['5.5 pts', '3,800'],
                      ['6.5 pts', '3,880'],
                      ['7.5 pts', '3,920'],
                      ['8.5 pts', '3,960'],
                      ['9.5 pts', '4,000'],
                      ['10.5 pts', '4,020'],
                      ['11.5 pts', '4,040'],
                      ['12.5 pts', '4,060'],
                      ['13.5 pts', '4,080'],
                      ['14.5 pts', '4,100'],
                      ['15.5 pts', '4,120'],
                      ['16.5 pts', '4,140'],
                      ['17.5 pts', '4,160'],
                      ['18.5 pts', '4,180'],
                      ['19.5 pts', '4,200'],
                      ['20.5 pts', '4,220'],
                      ['21.5 pts', '4,240'],
                      ['22.5 pts', '4,260'],
                      ['23.5 pts', '4,280'],
                      ['24.5 pts', '4,300'],
                      ['25.5 pts', '4,320'],
                      ['26.5 pts', '4,340'],
                      ['27.5 pts', '4,360'],
                      ['28.5 pts', '4,380'],
                      ['29.5 pts', '4,400'],
                      ['30.5 pts', '4,420'],
                      ['31.5 pts', '4,440'],
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
              const _InsetNote(
                title: 'Important notes',
                lines: [
                  'Early points above or below the spread have a more significant impact.',
                  'Decreases in share value are only half as severe as increases.',
                ],
              ),
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

          // Winning section
          _SectionCard(
            title: 'Part Five - Winning',
            paragraphs: const [
              'Aim to finish with the highest portfolio value.',
              'Go all in on a single game or diversify across many teams. Strategy is up to you.',
            ],
            children: const [
              SizedBox(height: 8),
              _InsetNote(
                title: 'Fair play',
                lines: [
                  'One account per person.',
                  'Administrators may correct obvious errors or incomplete lineups.',
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/* ---------- UI helpers ---------- */

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.paragraphs,
    this.bullets,
    this.children,
  });

  final String title;
  final List<String>? paragraphs;
  final List<String>? bullets;
  final List<Widget>? children;

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

class _LadderList extends StatelessWidget {
  const _LadderList({required this.rows});

  final List<List<String>> rows; // [margin, price]

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final divider = theme.dividerColor.withOpacity(0.15);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _LadderHeader(),
          const Divider(height: 1),
          ...rows.map(
            (r) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      r[0],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      r[1],
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium,
                    ),
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

class _LadderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Margin vs Spread',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'Resulting Price',
              textAlign: TextAlign.right,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
