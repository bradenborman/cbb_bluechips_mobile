import 'package:flutter/material.dart';

enum TradeType { buy, sell }

@immutable
class TransactionItem {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String teamName;
  final int volume; // shares
  final double amount; // positive credit, negative debit
  final TradeType type;
  final DateTime createdAt;

  const TransactionItem({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.teamName,
    required this.volume,
    required this.amount,
    required this.type,
    required this.createdAt,
  });
}

@immutable
class TransactionsOverview {
  final int totalTransactionsCount;
  final List<TransactionItem> transactions;

  const TransactionsOverview({
    required this.totalTransactionsCount,
    required this.transactions,
  });

  TransactionsOverview copyAppend(List<TransactionItem> more) =>
      TransactionsOverview(
        totalTransactionsCount: totalTransactionsCount,
        transactions: [...transactions, ...more],
      );

  TransactionsOverview copyReplace(List<TransactionItem> next) =>
      TransactionsOverview(
        totalTransactionsCount: totalTransactionsCount,
        transactions: next,
      );
}

@immutable
class TransactionsQuery {
  final int limit;
  final DateTime? after; // cursor; fetch items strictly after this instant
  final String? userId;

  const TransactionsQuery({this.limit = 20, this.after, this.userId});

  TransactionsQuery next(DateTime after) =>
      TransactionsQuery(limit: limit, after: after, userId: userId);
}
