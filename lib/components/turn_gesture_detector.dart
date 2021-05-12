import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_color_picker/tools/radial_drag_gesture_detector.dart';

class TurnGestureDetector extends StatefulWidget {
  const TurnGestureDetector({
    this.currentHue,
    this.maxHue,
    this.onHueSelected,
    this.child,
  });

  final double currentHue;
  final double maxHue;
  final Widget child;
  final Function(double) onHueSelected;

  @override
  _TurnGestureDetectorState createState() => _TurnGestureDetectorState();
}

class _TurnGestureDetectorState extends State<TurnGestureDetector> {
  PolarCoord startDragCoord;
  double startDragHue;

  void _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragHue = widget.currentHue;
  }

  void _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      final double angleDiff = coord.angle - startDragCoord.angle;
      final double anglePercent = angleDiff / (2 * pi);
      final double hueDiff = (anglePercent * widget.maxHue < 0)
          ? 360 + (anglePercent * widget.maxHue)
          : anglePercent * widget.maxHue;
      final double newHue = startDragHue + hueDiff > 360
          ? (360 - (startDragHue + hueDiff)).abs()
          : (startDragHue + hueDiff).abs();

      widget.onHueSelected(newHue);
    }
  }

  void _onRadialDragEnd() {
    startDragCoord = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      child: widget.child,
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
    );
  }
}
