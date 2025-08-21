import 'package:flutter/material.dart';

/// Shows either:
///  • "Favorite  -1.5" (red)
///  • "Underdog +1.5" (green)
/// Renders nothing if this team is neither favorite nor underdog, or spread is null.
class SpreadPill extends StatelessWidget {
  final String teamId;
  final String? favoriteTeamId;
  final String? underdogTeamId;
  final double? pointSpread;

  const SpreadPill({
    super.key,
    required this.teamId,
    required this.favoriteTeamId,
    required this.underdogTeamId,
    required this.pointSpread,
  });

  @override
  Widget build(BuildContext context) {
    if (pointSpread == null ||
        (favoriteTeamId == null && underdogTeamId == null)) {
      return const SizedBox.shrink();
    }

    final isFavorite = teamId == favoriteTeamId;
    final isUnderdog = teamId == underdogTeamId;
    if (!isFavorite && !isUnderdog) return const SizedBox.shrink();

    final label = isFavorite ? 'Favorite' : 'Underdog';
    final value = isFavorite
        ? '-${pointSpread!.abs().toStringAsFixed(1)}'
        : '+${pointSpread!.abs().toStringAsFixed(1)}';

    // joined pill look: [ Favorite ] [ -1.5 ]
    final Color left = isFavorite
        ? const Color(0xFFE86A6A)
        : const Color(0xFF30B46C);
    final Color right = isFavorite
        ? const Color(0xFFD95B5B)
        : const Color(0xFF2AA660);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // color backgrounds split so borders look crisp on dark themes
        Container(
          decoration: BoxDecoration(
            color: left,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: const SizedBox.shrink(),
        ),
        Container(
          decoration: BoxDecoration(
            color: right,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
