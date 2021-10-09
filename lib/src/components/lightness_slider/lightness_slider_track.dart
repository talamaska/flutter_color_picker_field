import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'lightness_slider.dart';

/// A custom slider track for the opacity slider.
///
/// Has rounded edges and a background image that repeats to show the common
/// image pattern used as background on images that has transparency. It
/// results in a nice effect where we can better judge visually how transparent
/// the current opacity value is directly on the slider.
class LightnessSliderTrack extends SliderTrackShape {
  /// Constructor for the opacity slider track.
  LightnessSliderTrack({
    required this.color,
    required this.textDirection,
    this.thumbRadius = lightnessThumbRadius,
  });

  /// Currently selected color.
  final Color color;

  final TextDirection textDirection;

  /// The radius of the adjustment thumb on the opacity slider track.
  ///
  /// Defaults to 14.
  final double thumbRadius;

  /// Returns a rect that represents the track bounds that fits within the
  /// [Slider].
  ///
  /// The width is the width of the [Slider] or [RangeSlider], but padded by
  /// the max  of the overlay and thumb radius. The height is defined by the
  /// [SliderThemeData.trackHeight].
  ///
  /// The [Rect] is centered both horizontally and vertically within the slider
  /// bounds.
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbWidth =
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0, 'overlayWidth must be >= 0');
    assert(trackHeight >= 0, 'trackHeight must be >= 0');

    final double trackLeft =
        offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox size less than slider's size the trackRight will
    // be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null,
        'disabledActiveTrackColor cannot be null.');
    assert(sliderTheme.disabledInactiveTrackColor != null,
        'disabledInactiveTrackColor cannot be null.');
    assert(sliderTheme.activeTrackColor != null,
        'activeTrackColor cannot be null.');
    assert(sliderTheme.inactiveTrackColor != null,
        'inactiveTrackColor cannot be null.');
    assert(sliderTheme.thumbShape != null, 'thumbShape cannot be null.');

    // If we have no track height, no point in doing anything, no-op exit.
    if ((sliderTheme.trackHeight ?? 0) <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    final Paint activePaint = Paint()..color = Colors.transparent;
    final HSLColor hsl = HSLColor.fromColor(color);

    List<Color> colors = <Color>[
      const Color(0xFF000000),
      const Color(0xFFFFFFFF),
    ];
    if (textDirection == TextDirection.rtl) {
      colors = colors.reversed.toList();
    }

    final Paint inactivePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(trackRect.width, 0),
        colors,
        <double>[0.01, 0.99],
      );

    final Paint colorPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(trackRect.width, 0),
        <Color>[
          hsl.withAlpha(0).toColor(),
          hsl.withAlpha(1.0).toColor(),
          hsl.withAlpha(0).toColor(),
        ],
        <double>[0.01, 0.5, 0.99],
      );

    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final RRect shapeRect = ui.RRect.fromLTRBAndCorners(
      trackRect.left - thumbRadius,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      trackRect.right + thumbRadius,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
      topLeft: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      bottomLeft: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      topRight: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      bottomRight: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
    );

    Path shadowPath = Path();
    shadowPath.addRRect(shapeRect);
    context.canvas.drawShadow(shadowPath, Colors.black, 1.5, true);

    context.canvas.drawRRect(shapeRect, leftTrackPaint);
    context.canvas.drawRRect(shapeRect, rightTrackPaint);
    context.canvas.drawRRect(shapeRect, colorPaint);
  }
}
