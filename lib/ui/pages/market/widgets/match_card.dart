// lib/ui/pages/market/widgets/match_card.dart
import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';

import 'date_label.dart';
import 'price_pill.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final started = match.startTime;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: date left, subtle status right
          Row(
            children: [
              Expanded(
                child: DateLabel(
                  dateTime: started,
                  fallback: match.completed ? 'Final' : 'TBD',
                ),
              ),
              _StatusChip(text: match.completed ? 'Completed' : 'Open'),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: Home header (seed + name/record, price on right)
          _TeamHeaderRow(
            team: match.homeTeam,
            onTap: () => _openTrade(context, match.homeTeam.teamId),
          ),
          // Row 3: Home meta compressed on one line
          _MetaLine(
            teamId: match.homeTeam.teamId,
            favoriteTeamId: match.favoriteTeamId,
            underdogTeamId: match.underdogTeamId,
            pointSpread: match.pointSpread,
            sharesOutstanding: match.homeTeam.sharesOutstanding,
          ),

          // Divider with tiny vs — spaced out a smidge more
          const SizedBox(height: 12),
          const _VsDivider(),
          const SizedBox(height: 12),

          // Row 4: Away header
          _TeamHeaderRow(
            team: match.awayTeam,
            onTap: () => _openTrade(context, match.awayTeam.teamId),
          ),
          // Row 5: Away meta
          _MetaLine(
            teamId: match.awayTeam.teamId,
            favoriteTeamId: match.favoriteTeamId,
            underdogTeamId: match.underdogTeamId,
            pointSpread: match.pointSpread,
            sharesOutstanding: match.awayTeam.sharesOutstanding,
          ),
        ],
      ),
    );
  }

  void _openTrade(BuildContext context, String teamId) {
    Navigator.pushNamed(
      context,
      '/trade',
      arguments: {'teamId': teamId, 'from': 'market'},
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  const _StatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCompleted = text.toLowerCase().startsWith('comp');
    final dotColor = isCompleted ? cs.tertiary : cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamHeaderRow extends StatelessWidget {
  final Team team;
  final VoidCallback? onTap;
  const _TeamHeaderRow({required this.team, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final seed = (team.seed ?? '').trim();
    final record = team.teamRecord != null
        ? ' (${team.teamRecord!.wins}-${team.teamRecord!.losses})'
        : '';
    final name = '${team.teamName}$record';

    // Team color from API (CSV "r,g,b" preferred), then css rgb(), then hex.
    final apiColor = _parseTeamColor(team.primaryColor, team.secondaryColor);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (seed.isNotEmpty) ...[
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (apiColor ?? cs.outlineVariant).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: (apiColor ?? cs.outlineVariant).withOpacity(0.35),
                  ),
                ),
                child: Text(
                  seed,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                // Leave team name in default onSurface color
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            // Keep your existing non-compact price formatting
            PricePill(value: team.currentMarketPrice),
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final String teamId;
  final String? favoriteTeamId;
  final String? underdogTeamId;
  final double? pointSpread;
  final String? sharesOutstanding;

  const _MetaLine({
    required this.teamId,
    required this.favoriteTeamId,
    required this.underdogTeamId,
    required this.pointSpread,
    required this.sharesOutstanding,
  });

  String _fmtSpread() {
    if (pointSpread == null) return '—';
    final v = pointSpread!.abs().toStringAsFixed(
      pointSpread!.abs() % 1 == 0 ? 0 : 1,
    );
    if (favoriteTeamId == teamId) return '-$v';
    if (underdogTeamId == teamId) return '+$v';
    return v;
  }

  String _fmtCount(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'Unknown';
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return raw;
    return digits.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
  }

  String _role() {
    if (favoriteTeamId == teamId) return 'Favorite';
    if (underdogTeamId == teamId) return 'Underdog';
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text =
        '${_role()} · ${_fmtSpread()} · Owned ${_fmtCount(sharesOutstanding)}';

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _VsDivider extends StatelessWidget {
  const _VsDivider();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Divider(color: cs.outlineVariant, height: 1, thickness: 1),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(
            'vs',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: cs.outlineVariant, height: 1, thickness: 1),
        ),
      ],
    );
  }
}

/* -------------------------- Color helpers -------------------------- */

/// Parse CSV "r,g,b" (e.g., "204,20,44").
Color? _parseRgbCsv(String? csv) {
  if (csv == null) return null;
  final parts = csv.split(',');
  if (parts.length < 3) return null;
  int? toC(String s) => int.tryParse(s.trim())?.clamp(0, 255);
  final r = toC(parts[0]);
  final g = toC(parts[1]);
  final b = toC(parts[2]);
  if (r == null || g == null || b == null) return null;
  return Color.fromARGB(255, r, g, b);
}

/// Parse CSS rgb(...) if it ever appears.
Color? _parseCssRgb(String? css) {
  if (css == null) return null;
  final m = RegExp(
    r'rgb\((\d+)\s*,\s*(\d+)\s*,\s*(\d+)\)',
    caseSensitive: false,
  ).firstMatch(css);
  if (m == null) return null;
  final r = int.parse(m.group(1)!);
  final g = int.parse(m.group(2)!);
  final b = int.parse(m.group(3)!);
  return Color.fromARGB(255, r, g, b);
}

/// Basic hex parser for #RRGGBB or #AARRGGBB.
Color? _parseHexColor(String? hex) {
  if (hex == null) return null;
  final raw = hex.trim().replaceAll('#', '');
  if (raw.isEmpty) return null;
  final v = (raw.length == 6) ? 'FF$raw' : raw; // add alpha if missing
  try {
    return Color(int.parse(v, radix: 16));
  } catch (_) {
    return null;
  }
}

/// Prefer CSV "r,g,b", then css rgb(), then hex; try primary, then secondary.
Color? _parseTeamColor(String? primary, String? secondary) {
  return _parseRgbCsv(primary) ??
      _parseCssRgb(primary) ??
      _parseHexColor(primary) ??
      _parseRgbCsv(secondary) ??
      _parseCssRgb(secondary) ??
      _parseHexColor(secondary);
}
