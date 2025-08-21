// Defines MarketResponse, Match, Team used by the Market page + service.

import 'dart:convert';
import 'package:cbb_bluechips_mobile/models/models.dart' show TeamRecord;

/// Helper if you need a quick decode locally; your app already has decodeJson,
/// but keeping this here avoids circular deps if you ever use this standalone.
Map<String, dynamic> _asMap(String body) =>
    json.decode(body) as Map<String, dynamic>;

class MarketResponse {
  final List<Match> matches;
  MarketResponse({required this.matches});

  factory MarketResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['matches'] as List<dynamic>? ?? [])
        .map((e) => Match.fromJson(e as Map<String, dynamic>))
        .toList();
    return MarketResponse(matches: list);
  }

  factory MarketResponse.fromBody(String body) =>
      MarketResponse.fromJson(_asMap(body));
}

class Match {
  final String matchId;
  final DateTime? startTime;
  final int? dayScheduled;
  final Team homeTeam;
  final Team awayTeam;
  final double? pointSpread;
  final String? favoriteTeamId;
  final String? underdogTeamId;
  final String? winningTeamId;
  final String? losingTeamId;
  final int? winningTeamScore;
  final int? losingTeamScore;
  final bool completed;

  Match({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    this.startTime,
    this.dayScheduled,
    this.pointSpread,
    this.favoriteTeamId,
    this.underdogTeamId,
    this.winningTeamId,
    this.losingTeamId,
    this.winningTeamScore,
    this.losingTeamScore,
    this.completed = false,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(String? v) => v == null ? null : DateTime.tryParse(v);
    int? asInt(dynamic v) =>
        (v is num) ? v.toInt() : int.tryParse('${v ?? ''}');

    return Match(
      matchId: json['matchId']?.toString() ?? '',
      startTime: parseDt(json['startTime'] as String?),
      dayScheduled: (json['dayScheduled'] as num?)?.toInt(),
      homeTeam: Team.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: Team.fromJson(json['awayTeam'] as Map<String, dynamic>),
      pointSpread: (json['pointSpread'] as num?)?.toDouble(),
      favoriteTeamId: json['favoriteTeamId'] as String?,
      underdogTeamId: json['underdogTeamId'] as String?,
      winningTeamId: json['winningTeamId'] as String?,
      losingTeamId: json['losingTeamId'] as String?,
      winningTeamScore: asInt(json['winningTeamScore']),
      losingTeamScore: asInt(json['losingTeamScore']),
      completed: (json['completed'] as bool?) ?? false,
    );
  }
}

class Team {
  final String teamId;
  final String teamName;

  final bool? eliminated;
  final bool? locked;

  final String? seed;
  final DateTime? nextGameTime;

  final double? currentMarketPrice;
  final String? sharesOutstanding;

  final TeamRecord? teamRecord;

  final String? nickname;
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;

  final bool? doesUserOwn;

  Team({
    required this.teamId,
    required this.teamName,
    this.eliminated,
    this.locked,
    this.seed,
    this.nextGameTime,
    this.currentMarketPrice,
    this.sharesOutstanding,
    this.teamRecord,
    this.nickname,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.doesUserOwn,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(String? v) => v == null ? null : DateTime.tryParse(v);
    return Team(
      teamId: json['teamId']?.toString() ?? '',
      teamName: json['teamName']?.toString() ?? '',
      eliminated: json['eliminated'] as bool?,
      locked: json['locked'] as bool?,
      seed: json['seed']?.toString(),
      nextGameTime: parseDt(json['nextGameTime'] as String?),
      currentMarketPrice: (json['currentMarketPrice'] as num?)?.toDouble(),
      sharesOutstanding: json['sharesOutstanding']?.toString(),
      // teamRecord exists in your global models; if not present it will be null.
      teamRecord: json['teamRecord'] is Map<String, dynamic>
          ? TeamRecord.fromJson(json['teamRecord'] as Map<String, dynamic>)
          : null,
      nickname: json['nickname']?.toString(),
      primaryColor: json['primaryColor']?.toString(),
      secondaryColor: json['secondaryColor']?.toString(),
      logoUrl: json['logoUrl']?.toString(),
      doesUserOwn: json['doesUserOwn'] as bool?,
    );
  }
}
