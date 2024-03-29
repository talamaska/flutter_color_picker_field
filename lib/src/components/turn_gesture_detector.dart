import 'dart:math';

import 'package:flutter/widgets.dart';

import '../tools/radial_drag_gesture_detector.dart';

class TurnGestureDetector extends StatefulWidget {
  const TurnGestureDetector({
    Key? key,
    required this.currentValue,
    required this.maxValue,
    this.child,
    this.onChanged,
  }) : super(key: key);

  final double currentValue;
  final double maxValue;
  final Widget? child;
  final ValueChanged<double>? onChanged;

  @override
  State<TurnGestureDetector> createState() => _TurnGestureDetectorState();
}

class _TurnGestureDetectorState extends State<TurnGestureDetector> {
  PolarCoord? startDragCoord;
  late double startDragValue;

  void _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragValue = widget.currentValue;
  }

  void _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      final double angleDiff = coord.angle - startDragCoord!.angle;
      final double anglePercent = angleDiff / (2 * pi);
      final double hueDiff = (anglePercent * widget.maxValue < 0)
          ? 360 + (anglePercent * widget.maxValue)
          : anglePercent * widget.maxValue;
      final double newHue = startDragValue + hueDiff > 360
          ? (360 - (startDragValue + hueDiff)).abs()
          : (startDragValue + hueDiff).abs();

      widget.onChanged?.call(newHue);
    }
  }

  void _onRadialDragEnd() {
    startDragCoord = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
      child: widget.child,
    );
  }
}
