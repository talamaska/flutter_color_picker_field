import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../tools/colors_painter.dart';

class ColorGradientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('build gradient');
    return CustomPaint(
      painter: const ColorsPainter(),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x00000000),
          shape: BoxShape.circle,
        ),
        height: double.infinity,
        width: double.infinity,
        child: FractionallySizedBox(
          widthFactor: 0.75,
          heightFactor: 0.75,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
