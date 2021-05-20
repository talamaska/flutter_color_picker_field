import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColorGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: FractionalOffset.center,
          startAngle: 0.0,
          endAngle: 2 * pi,
          colors: <Color>[
            Color(0xFFFF0000), // red
            Color(0xFFFFBF00), // yellow
            Color(0xFF80FF00), // electric green
            Color(0xFF00FF40), // green
            Color(0xFF00FFFF), // cyan
            Color(0xFF0040FF), // blue
            Color(0xFF7F00FF), // rose
            Color(0xFFFF00BF), // purple
            Color(0xFFFF0000), // red
          ],
          stops: <double>[
            0.0,
            0.125,
            0.25,
            0.375,
            0.5,
            0.625,
            0.75,
            0.875,
            1.0,
          ],
        ),
      ),
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
