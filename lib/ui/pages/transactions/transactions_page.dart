import 'package:flutter/material.dart';
import 'models.dart';
import 'transactions_service.dart';
import 'widgets/transaction_created_at.dart';
import 'widgets/transaction_list_header.dart';
import 'widgets/transaction_row.dart';
import 'widgets/load_more_button.dart';
import 'widgets/loading_spinner.dart';
import 'widgets/unable_to_load_message.dart';

class TransactionsPage extends StatefulWidget {
  static const route = '/transactions';

  /// You can pass `arguments: {'userId': 'u1'}` to filter by a specific user.
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _service = TransactionsService();

  var _status = _Status.loading;
  late TransactionsQuery _query;
  TransactionsOverview _overview = const TransactionsOverview(
    totalTransactionsCount: 0,
    transactions: [],
  );

  @override
  void initState() {
    super.initState();
    // pick up optional userId from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String? userId;
      if (args is Map && args['userId'] is String) {
        userId = args['userId'] as String;
      }
      _query = TransactionsQuery(limit: 20, userId: userId);
      _fetch(reset: true);
    });
  }

  Future<void> _fetch({bool reset = false}) async {
    try {
      if (reset) {
        setState(() {
          _status = _Status.loading;
          _overview = const TransactionsOverview(
            totalTransactionsCount: 0,
            transactions: [],
          );
          _query = TransactionsQuery(
            limit: _query.limit,
            userId: _query.userId,
          );
        });
      } else {
        setState(() => _status = _Status.loading);
      }

      final res = await _service.fetch(_query);
      setState(() {
        _status = _Status.idle;
        _overview = reset ? res : _overview.copyAppend(res.transactions);
      });
    } catch (_) {
      setState(() => _status = _Status.error);
    }
  }

  DateTime? _nextCursor() {
    if (_overview.transactions.isEmpty) return null;
    // cursor = createdAt of the last row (ascending window in service)
    final last = _overview.transactions.last;
    return last.createdAt;
  }

  bool get _isEndOfList =>
      _overview.transactions.length >= _overview.totalTransactionsCount &&
      _overview.totalTransactionsCount > 0;

  void _clearUserFilter() {
    setState(() {
      _query = TransactionsQuery(limit: _query.limit, userId: null);
    });
    _fetch(reset: true);
  }

  void _openUser(String userId) {
    setState(() {
      _query = TransactionsQuery(limit: 20, userId: userId);
    });
    _fetch(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = (_query.userId != null && _query.userId!.isNotEmpty);

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasFilter)
          TextButton(
            onPressed: _clearUserFilter,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('View all transactions'),
            ),
          ),
        TransactionListHeader(
          // mirrors “Player | Team | Amount | Date” desktop header
          playerLabel: 'Player',
          teamLabel: 'Team',
          amountLabel: 'Amount',
          dateLabel: 'Date',
        ),
      ],
    );

    final list = Column(
      children: _overview.transactions.map((t) {
        return TransactionRow(
          item: t,
          onOpenUser: _openUser,
          trailingDate: TransactionCreatedAt(timestamp: t.createdAt),
        );
      }).toList(),
    );

    final loadMore = switch (_status) {
      _Status.idle =>
        _isEndOfList
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: UnableToLoadMessage(text: 'End of transactions'),
              )
            : LoadMoreButton(
                onLoad: () {
                  final cursor = _nextCursor();
                  if (cursor == null) return;
                  setState(() {
                    _query = _query.next(cursor);
                  });
                  _fetch(reset: false);
                },
              ),
      _Status.loading => const LoadingSpinner(wrapped: true),
      _Status.error => const UnableToLoadMessage(
        text: 'Unable to load transactions.',
      ),
    };

    final emptyState =
        (_status == _Status.idle && _overview.transactions.isEmpty)
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: UnableToLoadMessage(
              text: 'There are no transactions to display.',
            ),
          )
        : const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: Column(
          children: [
            header,
            Expanded(child: ListView(children: [list, emptyState, loadMore])),
          ],
        ),
      ),
    );
  }
}

enum _Status { loading, idle, error }
