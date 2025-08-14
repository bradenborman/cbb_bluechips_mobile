import 'package:flutter/material.dart';
import '../theme.dart';

class DottedBackground extends StatelessWidget {
  final Widget child;
  const DottedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotsPainter(), child: child);
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.ice.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const r = 1.4;

    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), r, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
