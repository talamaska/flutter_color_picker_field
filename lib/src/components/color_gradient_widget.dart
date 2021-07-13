import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../tools/colors_painter.dart';

class ColorGradientWidget extends StatelessWidget {
  const ColorGradientWidget({
    Key? key,
    this.ratio = 0.75,
  }) : super(key: key);

  final double ratio;

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData ct = CupertinoTheme.of(context);

    // log('build gradient');
    return CustomPaint(
      painter: const ColorsPainter(),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: double.infinity,
        width: double.infinity,
        child: FractionallySizedBox(
          widthFactor: ratio,
          heightFactor: ratio,
          child: Container(
            decoration: BoxDecoration(
              color: ct.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
