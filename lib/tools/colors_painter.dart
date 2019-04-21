import 'dart:core' show bool, double, int, override;
import 'dart:math';

import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';

class ColorsPainter extends CustomPainter {
  const ColorsPainter({
    this.ticks = 360,
  });

  final int ticks;

  @override
  void paint(Canvas canvas, Size size) {
    const double rads = (2 * pi) / 360;
    const double step = 1.0;
    const double aliasing = 0.5;

    for (int i = 0; i < ticks; i++) {
      final double sRad = (i - aliasing) * rads;
      final double eRad = (i + step) * rads;
      final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      final Paint segmentPaint = drawSegment(i);
      canvas.drawArc(rect, sRad, sRad - eRad, true, segmentPaint);
    }
  }

  Paint drawSegment(int index) {
    final Paint line = Paint();
    final HslColor hsl = HslColor(h: index * 1.0, s: 1.0, l: 0.5, a: 255.0);
    final Color color = TinyColor.fromHSL(hsl).color;
    line.color = color;
    return line;
  }

  @override
  bool shouldRepaint(ColorsPainter oldDelegate) {
    return oldDelegate.ticks != ticks;
  }
}