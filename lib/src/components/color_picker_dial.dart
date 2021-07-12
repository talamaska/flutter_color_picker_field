import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColorPickerDial extends StatefulWidget {
  const ColorPickerDial({
    required this.hue,
    required this.ratio,
    required this.dialRatio,
    required this.color,
  });

  final double hue;
  final double ratio;
  final double dialRatio;
  final Color color;

  @override
  _ColorPickerDialState createState() => _ColorPickerDialState();
}

class _ColorPickerDialState extends State<ColorPickerDial> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: Angle.degrees(widget.hue).radians,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: widget.ratio,
          heightFactor: widget.ratio,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0x00000000),
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: widget.dialRatio,
                heightFactor: widget.dialRatio,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 0.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}