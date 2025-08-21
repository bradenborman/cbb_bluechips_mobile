import 'package:cbb_bluechips_mobile/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';
import 'package:cbb_bluechips_mobile/models/leaderboard.dart'
    show LeaderboardUser;

class LeaderboardData {
  final List<LeaderboardEntry> entries;
  final int? totalPlayers;

  const LeaderboardData({required this.entries, required this.totalPlayers});
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final double points;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
  });
}

class LeaderboardPage extends StatefulWidget {
  static const route = '/leaderboard';

  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<LeaderboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  String _formatNumber(double value) {
    final s = value.toStringAsFixed(0); // no decimals for "pts"
    final chars = s.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) buf.write(',');
      buf.write(chars[i]);
    }
    return buf.toString().split('').reversed.join('');
  }

  Future<LeaderboardData> _load() async {
    // Use your existing service; it should ultimately call ApiHttp under the hood.
    final resp = await LeaderboardApi.fetch(limit: 15, page: 1);

    final entries =
        resp.players
            .map(
              (LeaderboardUser u) => LeaderboardEntry(
                rank: u.ranking,
                name: u.displayName,
                // Keep UI label as "pts", value from netWorth
                points: u.netWorth,
              ),
            )
            .toList()
          ..sort((a, b) => a.rank.compareTo(b.rank));

    return LeaderboardData(
      entries: entries,
      totalPlayers: resp.totalPlayerCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return FutureBuilder<LeaderboardData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return _ErrorState(
            message: 'Could not load leaderboard',
            onRetry: () => setState(() => _future = _load()),
          );
        }

        final data = snap.data!;
        final hasTop = data.entries.isNotEmpty;
        final top3 = hasTop
            ? data.entries.take(3).toList()
            : const <LeaderboardEntry>[];
        final rest = hasTop
            ? data.entries.skip(3).take(12).toList()
            : const <LeaderboardEntry>[];

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: const Text('Leaderboard'),
              // No yourRank chip at all per request.
            ),

            if (!hasTop)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _InfoBanner(
                    title: 'Global standings coming soon',
                    subtitle:
                        'Once the API exposes global standings, this page will display the full Top 15 with podium.',
                  ),
                ),
              ),

            if (hasTop)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _Podium(top3: top3),
                ),
              ),

            if (hasTop)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        'Top 15',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.ice,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(showing ${data.entries.length > 15 ? 15 : data.entries.length}${data.totalPlayers != null ? ' of ${data.totalPlayers}' : ''})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (hasTop)
              SliverList.separated(
                itemCount: rest.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: onSurface.withOpacity(0.08),
                  indent: 72,
                ),
                itemBuilder: (context, i) {
                  final e = rest[i];
                  return ListTile(
                    leading: _RankCircle(rank: e.rank),
                    title: Text(
                      e.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${_formatNumber(e.points)} pts',
                      style: TextStyle(color: onSurface.withOpacity(0.6)),
                    ),
                  );
                },
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

// ——— Small helper widgets (unchanged styling) ———

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  const _InfoBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: on.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: on.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final items = List<LeaderboardEntry>.from(top3);
    while (items.length < 3) {
      items.add(
        LeaderboardEntry(rank: items.length + 1, name: 'TBD', points: 0),
      );
    }

    final second = items[1];
    final first = items[0];
    final third = items[2];

    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: onSurface.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumColumn(
              entry: second,
              height: 80,
              color: _metal('silver'),
            ),
          ),
          Expanded(
            child: _PodiumColumn(
              entry: first,
              height: 100,
              color: _metal('gold'),
              crown: true,
            ),
          ),
          Expanded(
            child: _PodiumColumn(
              entry: third,
              height: 60,
              color: _metal('bronze'),
            ),
          ),
        ],
      ),
    );
  }

  Color _metal(String type) {
    switch (type) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      default:
        return const Color(0xFFCD7F32);
    }
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final Color color;
  final bool crown;

  const _PodiumColumn({
    required this.entry,
    required this.height,
    required this.color,
    this.crown = false,
  });

  String _formatNumber(double value) {
    final s = value.toStringAsFixed(0);
    final chars = s.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) buf.write(',');
      buf.write(chars[i]);
    }
    return buf.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (crown)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Icon(Icons.emoji_events_rounded, color: color, size: 28),
          ),
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            entry.name.isNotEmpty
                ? entry.name.substring(0, 1).toUpperCase()
                : '?',
            style: TextStyle(
              color: on,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          '${_formatNumber(entry.points)} pts',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: on.withOpacity(0.7)),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.45)),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 32,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#${entry.rank}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: on,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankCircle extends StatelessWidget {
  final int rank;
  const _RankCircle({required this.rank});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = AppColors.bg;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: onSurface.withOpacity(0.1)),
      ),
      child: Center(
        child: Text(
          '$rank',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
