import 'package:flutter/material.dart';
import '../../../../models/models.dart';

class InvestmentList extends StatelessWidget {
  final List<Investment> items;
  final void Function(Investment)? onTap;

  /// Visual toggles to avoid truncation and keep a sleek row.
  final bool abbrevOnly; // show 2-letter ticker chip only (no long name)
  final bool showSeed;

  const InvestmentList({
    super.key,
    this.items = const [],
    this.onTap,
    this.abbrevOnly = false,
    this.showSeed = true,
  });

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
        // Header (no extra indent; tighter left edge)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          child: Row(
            children: [
              Expanded(flex: 1, child: Text('Team', style: headerStyle)),
              Expanded(
                flex: 3,
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
                flex: 4,
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
        ...items.map(
          (inv) => _InvestmentRow(
            inv: inv,
            onTap: onTap,
            abbrevOnly: abbrevOnly,
            showSeed: showSeed,
          ),
        ),
      ],
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  final Investment inv;
  final void Function(Investment)? onTap;
  final bool abbrevOnly;
  final bool showSeed;

  const _InvestmentRow({
    required this.inv,
    this.onTap,
    required this.abbrevOnly,
    required this.showSeed,
  });

  @override
  Widget build(BuildContext context) {
    final seedText = showSeed && inv.seed.isNotEmpty ? ' (${inv.seed})' : '';
    final ticker =
        (inv.teamName.length >= 2 ? inv.teamName.substring(0, 2) : inv.teamName)
            .toUpperCase();

    // Chip tweaks: smaller and tighter
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          children: [
            // Team cell (very narrow when abbrevOnly)
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ticker,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: tickerColor,
                      ),
                    ),
                  ),
                  if (!abbrevOnly) ...[
                    const SizedBox(width: 6),
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
                ],
              ),
            ),

            // Price
            Expanded(
              flex: 3,
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

            // Total (wider + chevron)
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _fmt(total),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Format with commas, e.g. 7282 -> 7,282
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

/// Support CSS rgb(...) strings from the API
Color? _parseCssRgb(String? css) {
  if (css == null) return null;
  final m = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)').firstMatch(css);
  if (m == null) return null;
  final r = int.parse(m.group(1)!);
  final g = int.parse(m.group(2)!);
  final b = int.parse(m.group(3)!);
  return Color.fromARGB(255, r, g, b);
}
