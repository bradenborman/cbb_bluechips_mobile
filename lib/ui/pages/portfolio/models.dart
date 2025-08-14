enum RequestStatus { idle, loading, error, success }

class Portfolio {
  final int leaderboardPosition;
  final int totalNetWorth;
  final int availableNetWorth;
  final int investmentsTotal;
  final int predictionPointsInvested;

  const Portfolio({
    required this.leaderboardPosition,
    required this.totalNetWorth,
    required this.availableNetWorth,
    required this.investmentsTotal,
    required this.predictionPointsInvested,
  });

  static const empty = Portfolio(
    leaderboardPosition: 0,
    totalNetWorth: 0,
    availableNetWorth: 0,
    investmentsTotal: 0,
    predictionPointsInvested: 0,
  );
}

class QuickSellTransaction {
  final String name;
  final int qty;
  final int points;
  const QuickSellTransaction({required this.name, required this.qty, required this.points});
}

class QuickSellAllResponse {
  final List<QuickSellTransaction> transactions;
  const QuickSellAllResponse({required this.transactions});

  static const empty = QuickSellAllResponse(transactions: []);
}