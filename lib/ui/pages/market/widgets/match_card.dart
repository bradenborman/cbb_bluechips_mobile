import 'package:flutter/material.dart';
import '../models.dart';

/// Stacked game tile:
/// [Header]
/// [Top team block]
/// [  centered ± spread pill  ]
/// [Bottom team block]
///
/// - Favorite tag only on the negative-spread team
/// - Price (unlabeled) then "Owned ####" under each name
/// - Score sits at the far right of each team block
/// - No Point Speed or extra icons on the card
class MatchCard extends StatelessWidget {
  final GameResult game;
  final void Function(TeamResult team, double pointSpeed) onTapTeam;

  const MatchCard({super.key, required this.game, required this.onTapTeam});

  @override
  Widget build(BuildContext context) {
    final played = formatShortTime(game.playedAt);
    final spreadMag = game.centerSpreadMagnitude;
    final dividerColor = Theme.of(context).dividerColor.withOpacity(0.18);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Final',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 6),
                Text(
                  played,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // New subtle divider so the top team doesn't feel larger
            const SizedBox(height: 10),
            Container(height: 1, color: dividerColor),
            const SizedBox(height: 10),

            // Top team (away)
            _TeamRow(
              team: game.away,
              isHome: false,
              isFavorite: game.away.isFavorite,
              score: game.away.finalScore,
              priceText: formatMoney(game.away.marketPrice),
              ownedText: 'Owned ${game.away.totalSharesOwned}',
              onTap: () => onTapTeam(game.away, game.pointSpeedFor(game.away)),
            ),

            const SizedBox(height: 10),

            // Center "not-a-line" ± spread
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.black.withOpacity(0.10)),
                ),
                child: Text(
                  '± ${formatSpread(spreadMag)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Bottom team (home)
            _TeamRow(
              team: game.home,
              isHome: true,
              isFavorite: game.home.isFavorite,
              score: game.home.finalScore,
              priceText: formatMoney(game.home.marketPrice),
              ownedText: 'Owned ${game.home.totalSharesOwned}',
              onTap: () => onTapTeam(game.home, game.pointSpeedFor(game.home)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final TeamResult team;
  final bool isHome;
  final bool isFavorite;
  final int score;
  final String priceText;
  final String ownedText;
  final VoidCallback onTap;

  const _TeamRow({
    required this.team,
    required this.isHome,
    required this.isFavorite,
    required this.score,
    required this.priceText,
    required this.ownedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(team.logoAsset),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),

          // Name + price/owned
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Single-line name with optional "(Home)" and Favorite pill
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isHome ? '${team.name} (Home)' : team.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isFavorite) ...[
                      const SizedBox(width: 8),
                      _favoritePill(context),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  priceText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ownedText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Score rail (right aligned)
          Text(
            score.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _favoritePill(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.14), // subtle tint
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.38)), // clearer edge
      ),
      child: Text(
        'Favorite',
        maxLines: 1,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800, // slight emphasis
          color: primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
