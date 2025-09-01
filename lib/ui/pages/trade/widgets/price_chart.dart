import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Simple, dependency-free sparkline used by the Recent Prices card.
/// Pass prices in chronological order (oldest → newest).
class PriceChart extends StatelessWidget {
  final List<num> prices;
  final String Function(num)? tooltipFmt; // optional, reserved for future

  const PriceChart({
    super.key,
    required this.prices,
    this.tooltipFmt,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 140,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface, // subtle contrast inside the card
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomPaint(
          painter: _PricePainter(
            prices: prices,
            lineColor: cs.primary,
            fillTop: cs.primary.withValues(alpha: 0.20),
            fillBottom: cs.primary.withValues(alpha: 0.00),
            gridColor: cs.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _PricePainter extends CustomPainter {
  final List<num> prices;
  final Color lineColor;
  final Color fillTop;
  final Color fillBottom;
  final Color gridColor;

  _PricePainter({
    required this.prices,
    required this.lineColor,
    required this.fillTop,
    required this.fillBottom,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Guard: nothing to draw
    if (prices.isEmpty) {
      _drawCenteredText(canvas, size, 'No data');
      return;
    }
    if (prices.length == 1) {
      // Single point -> draw a dot at center line
      final p = prices.first.toDouble();
      final y = size.height / 2;
      final x = size.width / 2;
      final dot = Paint()..color = lineColor;
      canvas.drawCircle(Offset(x, y), 3, dot);
      return;
    }

    // Chart paddings
    const padL = 8.0, padR = 8.0, padT = 10.0, padB = 12.0;
    final w = math.max(1, size.width - padL - padR);
    final h = math.max(1, size.height - padT - padB);

    // Min/max
    double minV = prices.first.toDouble();
    double maxV = prices.first.toDouble();
    for (final v in prices) {
      final d = v.toDouble();
      if (d < minV) minV = d;
      if (d > maxV) maxV = d;
    }
    if (maxV == minV) {
      // Flat series, nudge range to avoid div-by-zero
      maxV += 1;
      minV -= 1;
    }

    // Helpers to map -> canvas
    double xFor(int i) => padL + (i / (prices.length - 1)) * w;
    double yFor(double v) {
      final t = (v - minV) / (maxV - minV); // 0..1
      return padT + (1 - t) * h; // invert so larger is higher
    }

    // Optional subtle grid (3 horizontals)
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int g = 0; g < 3; g++) {
      final gy = padT + (g / 2) * h;
      canvas.drawLine(Offset(padL, gy), Offset(size.width - padR, gy), gridPaint);
    }

    // Build path
    final line = Path();
    final fill = Path();
    for (int i = 0; i < prices.length; i++) {
      final x = xFor(i);
      final y = yFor(prices[i].toDouble());
      if (i == 0) {
        line.moveTo(x, y);
        fill.moveTo(x, y);
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }

    // Close fill to bottom
    fill
      ..lineTo(padL + w, padT + h)
      ..lineTo(padL, padT + h)
      ..close();

    // Draw fill
    final shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [fillTop, fillBottom],
    ).createShader(rect);
    final fillPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;
    canvas.drawPath(fill, fillPaint);

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(line, linePaint);

    // Draw last-point dot
    final last = Offset(xFor(prices.length - 1), yFor(prices.last.toDouble()));
    final dot = Paint()..color = lineColor;
    canvas.drawCircle(last, 3, dot);
  }

  void _drawCenteredText(Canvas canvas, Size size, String text) {
    final pb = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
      ..pushStyle(TextStyle(color: const Color(0x99000000), fontSize: 12))
      ..addText(text);
    final paragraph = pb.build()
      ..layout(ParagraphConstraints(width: size.width));
    canvas.drawParagraph(
      paragraph,
      Offset(0, (size.height - paragraph.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _PricePainter old) =>
      old.prices != prices ||
      old.lineColor != lineColor ||
      old.fillTop != fillTop ||
      old.fillBottom != fillBottom ||
      old.gridColor != gridColor;
}
