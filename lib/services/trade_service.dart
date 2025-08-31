// lib/services/trade_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_client.dart';

class TradeService {
  const TradeService();

  /// GET /api/trade-details/{teamId}?userId=...
  Future<TeamTradeDetailsResponse> getTradeDetails({
    required String userId,
    required String teamId,
  }) async {
    final http.Response res = await ApiHttp.get(
      '/api/trade-details/$teamId',
      query: {'userId': userId},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return TeamTradeDetailsResponse.fromJson(jsonDecode(res.body));
    }
    throw Exception(
      'Failed to load trade details: ${res.statusCode} ${res.body}',
    );
  }
}

/// ======== MODELS (mapped to your API schema) ========

class TeamTradeDetailsResponse {
  final String userId;
  final num purchasingPower;

  final String teamId; // NOTE: do NOT display in UI
  final String teamName;
  final num currentMarketPrice;
  final String? sharesOutstanding;

  final TeamRecord? teamRecord;
  final String? seed;

  final String? opposingTeamId; // keep for logic; don't display id in UI
  final String? opposingTeamName;

  final String? favoriteTeamId; // likewise
  final DateTime? startTime;

  final bool locked;
  final num? pointSpread;

  final String? nickname;
  final String? logoUrl;
  final String? primaryColor;

  final int amountSharesOwned;
  final int maximumCanPurchase;

  final bool userSubscribedToHelp;
  final bool conflictOfInterest;
  final bool allowAfterPlayedPurchase;
  final int? maxAmountPlayerCanHaveInvested;

  final List<PriceHistory> priceHistory;
  final List<TopShareholder> topShareholders;
  final List<YahooStory> yahooStories;

  TeamTradeDetailsResponse({
    required this.userId,
    required this.purchasingPower,
    required this.teamId,
    required this.teamName,
    required this.currentMarketPrice,
    this.sharesOutstanding,
    this.teamRecord,
    this.seed,
    this.opposingTeamId,
    this.opposingTeamName,
    this.favoriteTeamId,
    this.startTime,
    required this.locked,
    this.pointSpread,
    this.nickname,
    this.logoUrl,
    this.primaryColor,
    required this.amountSharesOwned,
    required this.maximumCanPurchase,
    required this.userSubscribedToHelp,
    required this.conflictOfInterest,
    required this.allowAfterPlayedPurchase,
    this.maxAmountPlayerCanHaveInvested,
    this.priceHistory = const [],
    this.topShareholders = const [],
    this.yahooStories = const [],
  });

  factory TeamTradeDetailsResponse.fromJson(Map<String, dynamic> j) {
    DateTime? _dt(String? s) {
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return TeamTradeDetailsResponse(
      userId: (j['userId'] ?? '').toString(),
      purchasingPower: (j['purchasingPower'] as num?) ?? 0,
      teamId: (j['teamId'] ?? j['id'] ?? '').toString(),
      teamName: (j['teamName'] ?? j['name'] ?? '').toString(),
      currentMarketPrice: (j['currentMarketPrice'] as num?) ?? 0,
      sharesOutstanding: j['sharesOutstanding']?.toString(),
      teamRecord: j['teamRecord'] != null
          ? TeamRecord.fromJson(j['teamRecord'] as Map<String, dynamic>)
          : null,
      seed: j['seed']?.toString(),
      opposingTeamId: j['opposingTeamId']?.toString(),
      opposingTeamName: j['opposingTeamName']?.toString(),
      favoriteTeamId: j['favoriteTeamId']?.toString(),
      startTime: _dt(j['startTime']?.toString()),
      locked: j['locked'] == true,
      pointSpread: j['pointSpread'] as num?,
      nickname: j['nickname']?.toString(),
      logoUrl: j['logoUrl']?.toString(),
      primaryColor: j['primaryColor']?.toString(),
      amountSharesOwned: (j['amountSharesOwned'] as int?) ?? 0,
      maximumCanPurchase: (j['maximumCanPurchase'] as int?) ?? 0,
      userSubscribedToHelp: j['userSubscribedToHelp'] == true,
      conflictOfInterest: j['conflictOfInterest'] == true,
      allowAfterPlayedPurchase: j['allowAfterPlayedPurchase'] == true,
      maxAmountPlayerCanHaveInvested:
          (j['maxAmountPlayerCanHaveInvested'] as int?),
      priceHistory:
          (j['priceHistory'] as List?)
              ?.map((e) => PriceHistory.fromJson(e))
              .toList() ??
          const [],
      topShareholders:
          (j['topShareholders'] as List?)
              ?.map((e) => TopShareholder.fromJson(e))
              .toList() ??
          const [],
      yahooStories:
          (j['yahooStories'] as List?)
              ?.map((e) => YahooStory.fromJson(e))
              .toList() ??
          const [],
    );
  }
}

class TeamRecord {
  final int wins;
  final int losses;
  const TeamRecord({required this.wins, required this.losses});
  factory TeamRecord.fromJson(Map<String, dynamic> j) => TeamRecord(
    wins: (j['wins'] as int?) ?? 0,
    losses: (j['losses'] as int?) ?? 0,
  );
}

class PriceHistory {
  final String marketValueId;
  final String teamId; // keep for logic if needed; don't display
  final String roundId;
  final num price;
  const PriceHistory({
    required this.marketValueId,
    required this.teamId,
    required this.roundId,
    required this.price,
  });
  factory PriceHistory.fromJson(Map<String, dynamic> j) => PriceHistory(
    marketValueId: (j['marketValueId'] ?? '').toString(),
    teamId: (j['teamId'] ?? '').toString(),
    roundId: (j['roundId'] ?? '').toString(),
    price: (j['price'] as num?) ?? 0,
  );
}

class TopShareholder {
  final String userId; // you may hide this in UI if needed
  final String fullName;
  final int amountOwned;
  const TopShareholder({
    required this.userId,
    required this.fullName,
    required this.amountOwned,
  });
  factory TopShareholder.fromJson(Map<String, dynamic> j) => TopShareholder(
    userId: (j['userId'] ?? '').toString(),
    fullName: (j['fullName'] ?? '').toString(),
    amountOwned: (j['amountOwned'] as int?) ?? 0,
  );
}

class YahooStory {
  final String url;
  final String text;
  final String source;
  const YahooStory({
    required this.url,
    required this.text,
    required this.source,
  });
  factory YahooStory.fromJson(Map<String, dynamic> j) => YahooStory(
    url: (j['url'] ?? '').toString(),
    text: (j['text'] ?? '').toString(),
    source: (j['source'] ?? '').toString(),
  );
}
