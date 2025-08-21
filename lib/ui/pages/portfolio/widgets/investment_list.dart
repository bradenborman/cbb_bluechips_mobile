import 'package:flutter/material.dart';
import '../../../../models/models.dart';

class InvestmentList extends StatelessWidget {
  final List<Investment> items;
  final void Function(Investment)? onTap;

  const InvestmentList({super.key, this.items = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No active investments',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              const SizedBox(width: 4), // slight indent to align with chip
              Expanded(flex: 4, child: Text('Team', style: headerStyle)),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Price', style: headerStyle),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Shares', style: headerStyle),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Total', style: headerStyle),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Rows
        ...items.map((inv) => _InvestmentRow(inv: inv, onTap: onTap)),
      ],
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  final Investment inv;
  final void Function(Investment)? onTap;
  const _InvestmentRow({required this.inv, this.onTap});

  @override
  Widget build(BuildContext context) {
    final seedText = inv.seed.isNotEmpty ? ' (${inv.seed})' : '';
    final ticker =
        (inv.teamName.length >= 2 ? inv.teamName.substring(0, 2) : inv.teamName)
            .toUpperCase();

    // Background of the chip stays the same; text color uses primaryColor
    final chipBg = Theme.of(context).colorScheme.surfaceContainerHigh;
    final tickerColor =
        _parseCssRgb(inv.primaryColor) ?? Theme.of(context).colorScheme.primary;

    final price = inv.marketPrice;
    final shares = inv.amountOwned;
    final total = (price is num ? price : price as num) * shares;

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(inv),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            // Team
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ticker,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: tickerColor, // <- primaryColor as text color
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${inv.teamName}$seedText',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Expanded(
              flex: 2,
              child: Text(
                _fmt(price),
                textAlign: TextAlign.right,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),

            // Shares
            Expanded(
              flex: 2,
              child: Text(
                shares.toString(),
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Total (Price x Shares)
            Expanded(
              flex: 3,
              child: Text(
                _fmt(total),
                textAlign: TextAlign.right,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Format with commas, e.g. 7282 -> 7,282 (works for num/int)
String _fmt(num v) {
  final s = v.toInt().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idx = s.length - i;
    b.write(s[i]);
    if (idx > 1 && idx % 3 == 1) b.write(',');
  }
  return b.toString();
}

/// Support CSS rgb(...) strings from the API, e.g. "rgb(241, 197, 203)".
Color? _parseCssRgb(String? css) {
  if (css == null) return null;
  final m = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)').firstMatch(css);
  if (m == null) return null;
  final r = int.parse(m.group(1)!);
  final g = int.parse(m.group(2)!);
  final b = int.parse(m.group(3)!);
  return Color.fromARGB(255, r, g, b);
}
