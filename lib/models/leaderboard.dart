import 'dart:convert';

class LeaderboardResponse {
  final int totalPlayerCount;
  final List<LeaderboardUser> players;

  LeaderboardResponse({required this.totalPlayerCount, required this.players});

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      totalPlayerCount: json['totalPlayerCount'] as int,
      players: (json['players'] as List<dynamic>)
          .map((e) => LeaderboardUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static LeaderboardResponse fromJsonString(String body) =>
      LeaderboardResponse.fromJson(json.decode(body) as Map<String, dynamic>);
}

class LeaderboardUser {
  final String userId;
  final String displayName;
  final int ranking;
  final double netWorth;
  final bool vip;

  LeaderboardUser({
    required this.userId,
    required this.displayName,
    required this.ranking,
    required this.netWorth,
    required this.vip,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      ranking: json['ranking'] as int,
      netWorth: (json['netWorth'] as num).toDouble(),
      vip: json['vip'] as bool,
    );
  }
}