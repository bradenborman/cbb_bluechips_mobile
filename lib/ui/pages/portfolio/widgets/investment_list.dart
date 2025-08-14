import 'package:flutter/material.dart';

class InvestmentList extends StatelessWidget {
  const InvestmentList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _InvestmentRow(
        ticker: 'MIZ',
        name: 'Missouri',
        qty: 12,
        value: 24500,
        changePct: 3.4,
      ),
      _InvestmentRow(
        ticker: 'FLR',
        name: 'Florida',
        qty: 5,
        value: 9800,
        changePct: -1.2,
      ),
      _InvestmentRow(
        ticker: 'TEX',
        name: 'Texas',
        qty: 2,
        value: 5600,
        changePct: 0.9,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investments',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  final String ticker;
  final String name;
  final int qty;
  final int value;
  final double changePct;

  const _InvestmentRow({
    required this.ticker,
    required this.name,
    required this.qty,
    required this.value,
    required this.changePct,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = changePct >= 0 ? Colors.green : Colors.red;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Text(
              ticker,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$qty units',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${value.toString()}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${changePct.toStringAsFixed(1)}%',
                style: TextStyle(color: changeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}