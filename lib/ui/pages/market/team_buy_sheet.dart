import 'package:flutter/material.dart';
import 'models.dart';

class TeamBuySheet extends StatefulWidget {
  final TeamResult team;
  final double pointSpeed;

  /// Mock values; pass real values when wired to accounts/portfolio.
  final int userBalanceDollars;
  final int userOwnedShares; // your shares of THIS team

  const TeamBuySheet({
    super.key,
    required this.team,
    required this.pointSpeed,
    this.userBalanceDollars = 10000,
    this.userOwnedShares = 0,
  });

  @override
  State<TeamBuySheet> createState() => _TeamBuySheetState();
}

class _TeamBuySheetState extends State<TeamBuySheet> {
  int _qty = 0;

  int get _pricePerShare => widget.team.marketPrice;
  int get _maxShares =>
      _pricePerShare <= 0 ? 0 : widget.userBalanceDollars ~/ _pricePerShare;
  int get _totalCost => _qty * _pricePerShare;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),

            // Header: avatar + team name + price tag
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(widget.team.logoAsset),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatMoney(_pricePerShare),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _divider(context),

            // Team data (global)
            _InfoRow(label: 'Spread', value: formatSpread(widget.team.spread)),
            _InfoRow(
              label: 'Total Shares Owned',
              value: widget.team.totalSharesOwned.toString(),
            ),

            const SizedBox(height: 10),
            _SectionLabel('My Wallet'),
            const SizedBox(height: 6),

            // User data (distinct styling)
            _InfoRow(
              label: 'Balance',
              value: formatMoney(widget.userBalanceDollars),
              emphasize: true, // stands out from team data
            ),
            _InfoRow(
              label: 'Shares in My Portfolio',
              value: widget.userOwnedShares.toString(),
            ),

            const SizedBox(height: 12),

            // Quantity with slider
            if (_maxShares == 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Insufficient balance to buy a share.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ] else ...[
              Text(
                '$_qty',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _qty == 0
                    ? 'Select a quantity'
                    : 'Total ${formatMoney(_totalCost)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _qty.toDouble(),
                min: 0,
                max: _maxShares.toDouble(),
                divisions: _maxShares,
                onChanged: (v) => setState(() => _qty = v.round()),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Max $_maxShares',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Buy button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_qty > 0 && _maxShares > 0)
                    ? () {
                        Navigator.pop(context, _qty);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Purchased $_qty shares of ${widget.team.name} for ${formatMoney(_totalCost)}',
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(_qty > 0 ? 'Buy $_qty' : 'Buy'),
              ),
            ),

            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
    height: 1,
    color: Theme.of(context).dividerColor.withOpacity(0.18),
    margin: const EdgeInsets.only(bottom: 10),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final bool emphasize;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultValue = const TextStyle(fontWeight: FontWeight.w700);
    final emphasized = TextStyle(
      fontWeight: FontWeight.w900,
      color: Theme.of(context).colorScheme.primary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(
            value,
            style: valueStyle ?? (emphasize ? emphasized : defaultValue),
          ),
        ],
      ),
    );
  }
}
