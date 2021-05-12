import 'dart:core';

import 'package:angles/angles.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_color_picker/components/color_gradient_paint.dart';
import 'package:flutter_color_picker/components/color_knob.dart';

import 'package:flutter_color_picker/components/color_picker_dial.dart';
import 'package:flutter_color_picker/components/turn_gesture_detector.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    this.currentColor,
    this.saveColor,
    this.changeColor,
  });

  final Color currentColor;
  final Function saveColor;
  final Function changeColor;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor;
  }

  double _extractHue(Color color) {
    final HSLColor hslColor = HSLColor.fromColor(color);
    final double hue = hslColor.hue;
    return Angle.fromDegrees(hue).degrees;
  }

  void confirmColor() {
    widget.saveColor(_currentColor);
  }

  void _onHueSelected(double newHue) {
    setState(() {
      _currentColor = HSLColor.fromAHSL(1.0, newHue, 1.0, 0.5).toColor();
      widget.changeColor(_currentColor);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 45.0, right: 45.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 1.0)
                )
              ]),
            child: Stack(children: <Widget>[
              ColorGradientPaint(),

              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: TurnGestureDetector(
                  currentHue: _extractHue(_currentColor),
                  maxHue: 360.0,
                  onHueSelected: _onHueSelected,
                  child: Stack(
                    children: <Widget>[
                      ColorPickerDial(
                        hue: _extractHue(_currentColor),
                        color: _currentColor,
                        ratio: 0.96,
                        dialRatio: 0.09,
                      ),
                      ColorKnob(
                        color: _currentColor,
                        ratio: 0.75,
                        saveColor: confirmColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
