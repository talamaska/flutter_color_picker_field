import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// The [SaturationSliderThumb] is a custom version of [RoundSliderThumbShape]
/// that draws a circle as thumb, with [color] as color inside the thumb.
/// It also display's slider value inside the thumb.
///
/// The slider thumb theme color is used for the circle outline and text color
/// for the displayed value.
///
/// There is a shadow for the resting, pressed, hovered, and focused state.
///
/// See also:
///
///  * [Slider], which includes a thumb defined by this shape.
///  * [SliderTheme], which can be used to configure the thumb shape of all
///    sliders in a widget subtree.
class SaturationSliderThumb extends RoundSliderThumbShape {
  /// Create a slider thumb that draws a circle filled with [color]
  /// and shows the slider `value` * 100 in the thumb.
  const SaturationSliderThumb({
    required this.color,
    double enabledThumbRadius = 16.0,
    double? disabledThumbRadius,
    double elevation = 1.0,
    double pressedElevation = 4.0,
    this.orientation = Orientation.portrait,
  }) : super(
          enabledThumbRadius: enabledThumbRadius,
          disabledThumbRadius: disabledThumbRadius,
          elevation: elevation,
          pressedElevation: pressedElevation,
        );

  /// Color used to fill the inside of the thumb.
  final Color color;
  final Orientation orientation;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null,
        'disabledThumbColor cannot be null');
    assert(sliderTheme.thumbColor != null, 'thumbColor cannot be null');

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);
    final Path path = Path()
      ..addArc(
        Rect.fromCenter(
          center: center,
          width: 2 * radius,
          height: 2 * radius,
        ),
        0,
        pi * 2,
      );

    canvas.drawShadow(path, Colors.black, 1.5, true);
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    canvas.drawCircle(center, radius - 1.8, Paint()..color = color);

    final TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: enabledThumbRadius * 0.78,
        fontWeight: FontWeight.w600,
        color: sliderTheme.thumbColor,
      ),
      text: (value * 100).toStringAsFixed(0),
    );

    final Size size = parentBox.size;
    canvas.save();
    canvas.translate(
      size.width - (size.width - center.dx),
      size.height / 2,
    );
    if (orientation == Orientation.landscape) {
      canvas.rotate(vm.radians(90));
    }

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final Offset textCenter = Offset(
      -(textPainter.width / 2),
      -(textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
    canvas.restore();
  }
}
