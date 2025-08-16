import 'package:flutter/material.dart';
import '../../../theme.dart';

class LeaderboardPage extends StatefulWidget {
  static const route = '/leaderboard';
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final _repo = const LeaderboardRepository();

  late Future<LeaderboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return FutureBuilder<LeaderboardData>(
      future: _future,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data!;
        final top3 = data.entries.take(3).toList();
        final rest = data.entries.skip(3).take(12).toList();

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: const Text('Leaderboard'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(child: _PlayersChip(total: data.totalPlayers)),
                ),
              ],
            ),

            // Podium
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: _Podium(top3: top3),
              ),
            ),

            // Header for list
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Text(
                      'Top 15',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.ice,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(showing ${data.entries.length > 15 ? 15 : data.entries.length} of ${data.totalPlayers})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ranks 4–15 list
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
                    '${e.points.toStringAsFixed(0)} pts',
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

// ——— UI bits ———

class _PlayersChip extends StatelessWidget {
  final int total;
  const _PlayersChip({required this.total});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: onSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_alt_rounded, size: 16),
          const SizedBox(width: 6),
          Text(
            '$total',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
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
          '${entry.points.toStringAsFixed(0)} pts',
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

// ——— Mock data ———

class LeaderboardData {
  final List<LeaderboardEntry> entries;
  final int totalPlayers;
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

class LeaderboardRepository {
  const LeaderboardRepository();

  Future<LeaderboardData> fetchLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mocked top 15
    final entries = <LeaderboardEntry>[
      const LeaderboardEntry(rank: 1, name: 'Ava M.', points: 1845),
      const LeaderboardEntry(rank: 2, name: 'Jayden R.', points: 1822),
      const LeaderboardEntry(rank: 3, name: 'Mia S.', points: 1789),
      const LeaderboardEntry(rank: 4, name: 'Noah T.', points: 1762),
      const LeaderboardEntry(rank: 5, name: 'Liam P.', points: 1740),
      const LeaderboardEntry(rank: 6, name: 'Ella K.', points: 1718),
      const LeaderboardEntry(rank: 7, name: 'Zoe C.', points: 1704),
      const LeaderboardEntry(rank: 8, name: 'Ethan L.', points: 1688),
      const LeaderboardEntry(rank: 9, name: 'Olivia D.', points: 1677),
      const LeaderboardEntry(rank: 10, name: 'Mason F.', points: 1666),
      const LeaderboardEntry(rank: 11, name: 'Leo W.', points: 1651),
      const LeaderboardEntry(rank: 12, name: 'Sofia H.', points: 1639),
      const LeaderboardEntry(rank: 13, name: 'Henry B.', points: 1627),
      const LeaderboardEntry(rank: 14, name: 'Aria V.', points: 1612),
      const LeaderboardEntry(rank: 15, name: 'Jack Q.', points: 1601),
    ];

    // Mock total players
    const totalPlayers = 712;

    return LeaderboardData(entries: entries, totalPlayers: totalPlayers);
  }
}
