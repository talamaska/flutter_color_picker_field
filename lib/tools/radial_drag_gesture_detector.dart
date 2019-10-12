import 'dart:math' show Point, pi;

import 'package:flutter/material.dart';

/// Gesture detector that reports user drags in terms of [PolarCoord]s with the
/// origin at the center of the provided [child].
///
/// [PolarCoord]s are comprised of an angle and a radius (distance).
///
/// Use [onRadialDragStart], [onRadialDragUpdate], and [onRadialDragEnd] to
/// react to the respective radial drag events.
class RadialDragGestureDetector extends StatefulWidget {
  const RadialDragGestureDetector({
    this.onRadialDragStart,
    this.onRadialDragUpdate,
    this.onRadialDragEnd,
    this.child,
  });

  final RadialDragStart onRadialDragStart;
  final RadialDragUpdate onRadialDragUpdate;
  final RadialDragEnd onRadialDragEnd;
  final Widget child;



  @override
  _RadialDragGestureDetectorState createState() => _RadialDragGestureDetectorState();
}

class _RadialDragGestureDetectorState extends State<RadialDragGestureDetector> {
  void _onPanStart(DragStartDetails details) {
    if (null != widget.onRadialDragStart) {
      final PolarCoord polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragStart(polarCoord);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (null != widget.onRadialDragUpdate) {
      final PolarCoord polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragUpdate(polarCoord);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (null != widget.onRadialDragEnd) {
      widget.onRadialDragEnd();
    }
  }

  PolarCoord _polarCoordFromGlobalOffset(Offset globalOffset) {
    // Convert the user's global touch offset to an offset that is local to
    // this Widget.
    final Offset localTouchOffset = (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with it.
    final Point<double> localTouchPoint = Point<double>(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this Widget to act as the origin.
    final Point<double> originPoint = Point<double>(context.size.width / 2, context.size.height / 2);

    return PolarCoord.fromPoints(originPoint, localTouchPoint);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}

class PolarCoord {
  const PolarCoord(this.angle, this.radius);

  factory PolarCoord.fromPoints(Point<double> origin, Point<double> point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final Point<double> vectorPoint = point - origin;
    final Offset vector = Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return PolarCoord(
      vector.direction,
      vector.distance,
    );
  }


  final double angle;
  final double radius;


  @override
  String toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)}'
        ' at ${(angle / (2 * pi) * 360).toStringAsFixed(2)}°';
  }
}

typedef RadialDragStart = Function(PolarCoord startCoord);
typedef RadialDragUpdate = Function(PolarCoord updateCoord);
typedef RadialDragEnd = Function();