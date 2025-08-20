import 'dart:convert';

enum RequestStatus { idle, loading, error, success }

// ===== Portfolio Overview (GET /api/portfolio/overview) =====

class Portfolio {
  final int leaderboardPosition;
  final int totalNetWorth;
  final int availableNetWorth;
  final int investmentsTotal;
  final int predictionsTotal;
  final int predictionPointsInvested;
  final int predictionPointsReceived;
  final int predictionPointsSpent;
  final int userTransactionCount;

  const Portfolio({
    required this.leaderboardPosition,
    required this.totalNetWorth,
    required this.availableNetWorth,
    required this.investmentsTotal,
    required this.predictionsTotal,
    required this.predictionPointsInvested,
    required this.predictionPointsReceived,
    required this.predictionPointsSpent,
    required this.userTransactionCount,
  });

  static const empty = Portfolio(
    leaderboardPosition: 0,
    totalNetWorth: 0,
    availableNetWorth: 0,
    investmentsTotal: 0,
    predictionsTotal: 0,
    predictionPointsInvested: 0,
    predictionPointsReceived: 0,
    predictionPointsSpent: 0,
    userTransactionCount: 0,
  );

  factory Portfolio.fromJson(Map<String, dynamic> j) => Portfolio(
    leaderboardPosition: (j['leaderboardPosition'] ?? 0) as int,
    totalNetWorth: _asInt(j['totalNetWorth']),
    availableNetWorth: _asInt(j['availableNetWorth']),
    investmentsTotal: _asInt(j['investmentsTotal']),
    predictionsTotal: _asInt(j['predictionsTotal']),
    predictionPointsInvested: _asInt(j['predictionPointsInvested']),
    predictionPointsReceived: _asInt(j['predictionPointsReceived']),
    predictionPointsSpent: _asInt(j['predictionPointsSpent']),
    userTransactionCount: (j['userTransactionCount'] ?? 0) as int,
  );
}

// ===== Investments list (GET /api/portfolio/investments) =====

class TeamRecord {
  final int wins;
  final int losses;
  const TeamRecord({required this.wins, required this.losses});
  factory TeamRecord.fromJson(Map<String, dynamic> j) => TeamRecord(
    wins: (j['wins'] ?? 0) as int,
    losses: (j['losses'] ?? 0) as int,
  );
}

class Investment {
  final String teamId;
  final String teamName;
  final TeamRecord teamRecord;
  final String seed;
  final String primaryColor;
  final int
  marketPrice; // price is numeric(double) in API; we store as int points
  final int amountOwned;
  final bool outOfPlay;
  final bool locked;

  const Investment({
    required this.teamId,
    required this.teamName,
    required this.teamRecord,
    required this.seed,
    required this.primaryColor,
    required this.marketPrice,
    required this.amountOwned,
    required this.outOfPlay,
    required this.locked,
  });

  factory Investment.fromJson(Map<String, dynamic> j) => Investment(
    teamId: j['teamId'] as String,
    teamName: j['teamName'] as String,
    teamRecord: TeamRecord.fromJson(j['teamRecord'] as Map<String, dynamic>),
    seed: (j['seed'] ?? '') as String,
    primaryColor: (j['primaryColor'] ?? '') as String,
    marketPrice: _asInt(j['marketPrice']),
    amountOwned: (j['amountOwned'] ?? 0) as int,
    outOfPlay: (j['outOfPlay'] ?? false) as bool,
    locked: (j['locked'] ?? false) as bool,
  );
}

class PortfolioResponse {
  final List<Investment> usersInvestments;
  final bool userSubscribedToHelp;

  const PortfolioResponse({
    required this.usersInvestments,
    required this.userSubscribedToHelp,
  });

  factory PortfolioResponse.fromJson(Map<String, dynamic> j) =>
      PortfolioResponse(
        usersInvestments: ((j['usersInvestments'] as List?) ?? [])
            .map((e) => Investment.fromJson(e as Map<String, dynamic>))
            .toList(),
        userSubscribedToHelp: (j['userSubscribedToHelp'] ?? false) as bool,
      );
}

// ===== Sell All (POST /api/trade/sell-all) =====

class QuickSellTransaction {
  final String name;
  final int qty;
  final int points;
  const QuickSellTransaction({
    required this.name,
    required this.qty,
    required this.points,
  });

  factory QuickSellTransaction.fromTransactionJson(Map<String, dynamic> t) =>
      QuickSellTransaction(
        name: (t['teamName'] ?? '') as String,
        qty: (t['volumeTraded'] ?? 0) as int,
        points: _asInt(t['cashTraded']),
      );
}

class QuickSellAllResponse {
  final List<QuickSellTransaction> transactions;
  final int totalProceeds;

  const QuickSellAllResponse({
    required this.transactions,
    required this.totalProceeds,
  });

  static const empty = QuickSellAllResponse(transactions: [], totalProceeds: 0);

  factory QuickSellAllResponse.fromJson(Map<String, dynamic> j) {
    final tx = ((j['transactions'] as List?) ?? [])
        .map(
          (t) => QuickSellTransaction.fromTransactionJson(
            t as Map<String, dynamic>,
          ),
        )
        .toList();
    return QuickSellAllResponse(
      transactions: tx,
      totalProceeds: _asInt(j['totalProceeds']),
    );
  }
}

// ===== Helpers =====

int _asInt(Object? n) {
  if (n == null) return 0;
  if (n is int) return n;
  if (n is double) return n.round();
  if (n is String) return int.tryParse(n) ?? (double.tryParse(n)?.round() ?? 0);
  return 0;
}

Map<String, dynamic> decodeJson(String body) =>
    jsonDecode(body) as Map<String, dynamic>;