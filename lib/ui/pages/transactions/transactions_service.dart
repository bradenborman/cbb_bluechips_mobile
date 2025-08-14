import 'dart:math';
import 'models.dart';

/// Replace this mock with your real API calls to `/api/transactions?limit=&after=&userId=`
class TransactionsService {
  /// Simulates a server-side pagination window of 120 txns across multiple users.
  static final List<TransactionItem> _mock = _seed();

  Future<TransactionsOverview> fetch(TransactionsQuery q) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate network

    // server-style filtering
    Iterable<TransactionItem> items = _mock;
    if (q.userId != null && q.userId!.isNotEmpty) {
      items = items.where((t) => t.userId == q.userId);
    }
    if (q.after != null) {
      items = items.where((t) => t.createdAt.isAfter(q.after!));
    }

    // sort ascending by createdAt for stable pagination, then take first `limit`
    final sorted = items.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final page = sorted.take(q.limit).toList();

    // total count should be of the filtered set regardless of cursor
    final totalFilteredCount = (q.userId == null || q.userId!.isEmpty)
        ? _mock.length
        : _mock.where((t) => t.userId == q.userId).length;

    return TransactionsOverview(
      totalTransactionsCount: totalFilteredCount,
      transactions: page,
    );
  }
}

/// ----- Mock data seeding -----
List<TransactionItem> _seed() {
  final rand = Random(42);
  final users = [
    ['u1', 'Braden', 'Borman'],
    ['u2', 'Taylor', 'Reese'],
    ['u3', 'Jordan', 'Cruz'],
  ];
  final teams = [
    'Purdue BLUE',
    'UConn GOLD',
    'Houston BLUE',
    'UNC GOLD',
    'Arizona BLUE',
  ];

  DateTime now = DateTime.now().toUtc();
  final List<TransactionItem> all = [];

  int id = 1;
  for (int i = 0; i < 120; i++) {
    final u = users[i % users.length];
    final t = teams[i % teams.length];
    final volume = rand.nextInt(9) + 1;
    final price = (rand.nextDouble() * 20) + 5;
    final buy = rand.nextBool();
    final type = buy ? TradeType.buy : TradeType.sell;
    final amount = (buy ? -1 : 1) * (price * volume);
    now = now.subtract(Duration(minutes: rand.nextInt(180))); // walk back time

    all.add(
      TransactionItem(
        id: 'tx$id',
        userId: u[0],
        firstName: u[1],
        lastName: u[2],
        teamName: t,
        volume: volume,
        amount: double.parse(amount.toStringAsFixed(2)),
        type: type,
        createdAt: now,
      ),
    );
    id++;
  }

  all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return all;
}