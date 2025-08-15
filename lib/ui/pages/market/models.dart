import 'package:flutter/material.dart';

/// Domain models for the Market page. Mock data only here.

/// Point Speed is how far a team finished relative to the spread.
/// Example: Team favored by -4 and wins by 10 -> pointSpeed = +6
///          Team +3 underdog and loses by 1 -> pointSpeed = +2
class TeamResult {
  final String name;
  final int finalScore;

  /// Spread is negative if favored, positive if underdog.
  /// Display rule: never show a leading "+" for positive spreads.
  final double spread;

  /// Unlabeled market price, shown like "$3,500".
  /// Store as whole dollars to avoid float weirdness.
  final int marketPrice;

  /// Total shares owned across all players (global).
  final int totalSharesOwned;
  final String conference; // optional flavor
  final String logoAsset; // optional, can be a placeholder

  const TeamResult({
    required this.name,
    required this.finalScore,
    required this.spread,
    required this.marketPrice,
    required this.totalSharesOwned,
    required this.conference,
    required this.logoAsset,
  });

  bool get isFavorite => spread < 0;
}

class GameResult {
  final String id;
  final DateTime playedAt;
  final TeamResult home;
  final TeamResult away;

  const GameResult({
    required this.id,
    required this.playedAt,
    required this.home,
    required this.away,
  });

  int get homeMargin => home.finalScore - away.finalScore;
  int get awayMargin => away.finalScore - home.finalScore;

  /// Point Speed is margin - spread for the team.
  double pointSpeedFor(TeamResult t) {
    if (t.name == home.name) {
      return homeMargin - home.spread;
    } else {
      return awayMargin - away.spread;
    }
  }

  /// For the center pill, show a single magnitude (± X.X).
  /// Prefer the favorite's absolute spread if one exists,
  /// otherwise fall back to the max absolute spread.
  double get centerSpreadMagnitude {
    final fav = home.isFavorite ? home : (away.isFavorite ? away : null);
    if (fav != null) return fav.spread.abs();
    return home.spread.abs() >= away.spread.abs()
        ? home.spread.abs()
        : away.spread.abs();
  }
}

/// Filter options for the UI. Right now everything is finals.
enum MarketFilter { all, positiveSpeed, negativeSpeed }

/// Simple mock repository. Replace later with your real provider.
class MarketRepository {
  const MarketRepository();

  Future<List<GameResult>> fetchFinals() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _mock;
  }
}

final List<GameResult> _mock = [
  GameResult(
    id: 'g1',
    playedAt: DateTime(2025, 3, 22, 19, 5),
    home: TeamResult(
      name: 'Duke',
      finalScore: 78,
      spread: -3.5,
      marketPrice: 5000,
      totalSharesOwned: 14230,
      conference: 'ACC',
      logoAsset: 'assets/images/team_duke.png',
    ),
    away: TeamResult(
      name: 'UNC',
      finalScore: 70,
      spread: 3.5, // positive shows with no leading "+"
      marketPrice: 3500,
      totalSharesOwned: 16790,
      conference: 'ACC',
      logoAsset: 'assets/images/team_unc.png',
    ),
  ),
  GameResult(
    id: 'g2',
    playedAt: DateTime(2025, 3, 22, 20, 30),
    home: TeamResult(
      name: 'Kansas',
      finalScore: 65,
      spread: -5.0,
      marketPrice: 4800,
      totalSharesOwned: 15210,
      conference: 'Big 12',
      logoAsset: 'assets/images/team_kansas.png',
    ),
    away: TeamResult(
      name: 'Kentucky',
      finalScore: 68,
      spread: 5.0,
      marketPrice: 3600,
      totalSharesOwned: 13440,
      conference: 'SEC',
      logoAsset: 'assets/images/team_kentucky.png',
    ),
  ),
  GameResult(
    id: 'g3',
    playedAt: DateTime(2025, 3, 22, 21, 15),
    home: TeamResult(
      name: 'Gonzaga',
      finalScore: 82,
      spread: -1.5,
      marketPrice: 4200,
      totalSharesOwned: 11890,
      conference: 'WCC',
      logoAsset: 'assets/images/team_placeholder.png',
    ),
    away: TeamResult(
      name: 'Baylor',
      finalScore: 85,
      spread: 1.5,
      marketPrice: 3900,
      totalSharesOwned: 17110,
      conference: 'Big 12',
      logoAsset: 'assets/images/team_baylor.png',
    ),
  ),
];

/// ===== Helpers

String formatShortTime(DateTime dt) {
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour < 12 ? 'AM' : 'PM';
  return '$h:$m $ampm CT';
}

Color speedColor(BuildContext context, double speed) {
  if (speed > 0) return Colors.green;
  if (speed < 0) return Theme.of(context).colorScheme.secondary;
  return Colors.blueGrey;
}

/// Signed for Point Speed, keep leading "+" when positive.
String fmtSigned(double v) =>
    v >= 0 ? '+${v.toStringAsFixed(1)}' : v.toStringAsFixed(1);

/// Unsigned for spreads: never add a leading "+". Negatives still show "-".
String formatSpread(double v) => v.toStringAsFixed(1);

/// Dollars with thousands separators, no decimals (e.g., $3,500)
String formatMoney(int dollars) {
  final s = dollars.toString();
  final withCommas = s.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '\$$withCommas';
}
