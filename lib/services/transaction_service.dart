// lib/services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_client.dart';

import '../ui/pages/transactions/models.dart'; // adjust if your models live elsewhere

class TransactionsService {
  const TransactionsService();

  Future<TransactionsOverview> fetch(TransactionsQuery q) async {
    final params = <String, String>{
      'limit': '${q.limit}',
      if (q.userId != null && q.userId!.isNotEmpty) 'userId': q.userId!,
      if (q.after != null) 'after': _isoSecondZ(q.after!), // <- important
    };

    final http.Response res = await ApiHttp.get(
      '/api/transactions',
      query: params,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      // log body to help diagnose if it ever fails again
      // ignore: avoid_print
      print('GET /api/transactions ${res.statusCode} ${res.body}');
      throw Exception('Failed to load transactions');
    }

    final Map<String, dynamic> body =
        jsonDecode(res.body) as Map<String, dynamic>;
    final total = (body['totalTransactionsCount'] as num?)?.toInt() ?? 0;

    final List<TransactionItem> items = (body['transactions'] as List? ?? [])
        .map((e) => _fromApi(e as Map<String, dynamic>))
        .toList();

    return TransactionsOverview(
      totalTransactionsCount: total,
      transactions: items,
    );
  }

  // Format like 2025-03-18T04:12:34Z (strip fractional secs).
  String _isoSecondZ(DateTime dt) {
    final s = dt.toUtc().toIso8601String();
    final noFrac = s.contains('.') ? s.split('.').first : s;
    return noFrac.endsWith('Z') ? noFrac : '${noFrac}Z';
  }

  TransactionItem _fromApi(Map<String, dynamic> j) {
    final action = (j['tradeAction'] ?? '').toString();
    final type = action == 'SELL' ? TradeType.sell : TradeType.buy;

    final createdAtStr = (j['timeOfTransaction'] ?? '').toString();
    final createdAt =
        DateTime.tryParse(createdAtStr)?.toUtc() ?? DateTime.now().toUtc();

    // API gives the traded cash as positive magnitude; your UI shows absolute in list.
    final amount = (j['cashTraded'] as num?)?.toDouble() ?? 0.0;

    return TransactionItem(
      id: (j['transactionId'] ?? '').toString(),
      userId: (j['userId'] ?? '').toString(),
      firstName: (j['firstName'] ?? '').toString(),
      lastName: (j['lastName'] ?? '').toString(),
      teamName: (j['teamName'] ?? '').toString(),
      volume: (j['volumeTraded'] as num?)?.toInt() ?? 0,
      amount: amount.abs(),
      type: type,
      createdAt: createdAt,
    );
  }
}