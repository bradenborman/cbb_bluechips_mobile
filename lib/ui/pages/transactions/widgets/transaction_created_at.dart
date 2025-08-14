import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCreatedAt extends StatelessWidget {
  final DateTime timestamp;
  const TransactionCreatedAt({super.key, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final d = DateFormat.yMMMd().format(timestamp.toLocal());
    final t = DateFormat.jm().format(timestamp.toLocal());
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(d, style: style),
        const SizedBox(width: 6),
        const Text('·'),
        const SizedBox(width: 6),
        Text(t, style: style),
      ],
    );
  }
}
