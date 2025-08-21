import 'package:cbb_bluechips_mobile/models/leaderboard.dart';
import 'package:cbb_bluechips_mobile/services/http_client.dart' show ApiHttp;

class LeaderboardApi {
  LeaderboardApi._();

  static Future<LeaderboardResponse> fetch({
    int limit = 100,
    int page = 1,
  }) async {
    final res = await ApiHttp.get(
      '/api/leaderboard',
      query: {'limit': '$limit', 'page': '$page'},
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'Leaderboard request failed: ${res.statusCode} ${res.body}',
      );
    }

    return LeaderboardResponse.fromJsonString(res.body);
  }
  
}