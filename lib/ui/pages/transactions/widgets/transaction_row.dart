import 'package:flutter/material.dart';
import '../models.dart';

class TransactionRow extends StatelessWidget {
  final TransactionItem item;
  final void Function(String userId) onOpenUser;
  final Widget trailingDate;

  const TransactionRow({
    super.key,
    required this.item,
    required this.onOpenUser,
    required this.trailingDate,
  });

  Color _badgeColor(BuildContext context) {
    switch (item.type) {
      case TradeType.buy:
        return Colors.teal;
      case TradeType.sell:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _pluralize(String word, int n) => n == 1 ? word : '${word}s';
  String _amountAbs() => (item.amount.abs()).toStringAsFixed(2);

  String _typeLabel() => item.type.name.toUpperCase();

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium;

    // Desktop row
    final desktop = Row(
      children: [
        // Type badge
        Container(
          width: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          decoration: BoxDecoration(
            color: _badgeColor(context),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _typeLabel(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        // Player (clickable)
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () => onOpenUser(item.userId),
            child: Text(
              '${item.firstName} ${item.lastName}',
              style: titleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Team
        Expanded(
          flex: 2,
          child: Text(
            item.teamName,
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Amount + shares
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(_amountAbs(), style: titleStyle),
              const SizedBox(width: 6),
              Text(
                '(${item.volume} ${_pluralize("share", item.volume)})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        // Date
        Expanded(
          flex: 2,
          child: Align(alignment: Alignment.centerLeft, child: trailingDate),
        ),
      ],
    );

    // Mobile row
    final mobile = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _badgeColor(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _typeLabel(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                trailingDate,
              ],
            ),
            Text(item.teamName, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => onOpenUser(item.userId),
              child: Text(
                '${item.firstName} ${item.lastName}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  _amountAbs(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 6),
                Text(
                  '(${item.volume} ${_pluralize("share", item.volume)})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x1F000000))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 720) {
            return desktop;
          }
          return mobile;
        },
      ),
    );
  }
}
