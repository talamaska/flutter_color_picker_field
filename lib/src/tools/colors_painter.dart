import 'dart:core';
import 'dart:math' show pi;

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
    final HSLColor hsl = HSLColor.fromAHSL(1.0, index * 1.0, 1.0, 0.5);
    final Color color = hsl.toColor();
    line.color = color;
    return line;
  }

  @override
  bool shouldRepaint(ColorsPainter oldDelegate) {
    return oldDelegate.ticks != ticks;
  }
}
