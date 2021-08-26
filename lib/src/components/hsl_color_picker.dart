import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'color_gradient_widget.dart';
import 'color_picker_dial.dart';
import 'hsl_color_knob.dart';
import 'turn_gesture_detector.dart';

class HSLColorPicker extends StatelessWidget {
  const HSLColorPicker({
    Key? key,
    required this.currentColor,
    required this.hue,
    required this.saturation,
    required this.lightness,
    this.onSave,
    this.onChange,
  }) : super(key: key);

  final Color currentColor;
  final double hue;
  final double saturation;
  final double lightness;
  final ValueChanged<Color>? onSave;
  final ValueChanged<Color>? onChange;

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData ct = CupertinoTheme.of(context);
    return Container(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: ct.brightness == Brightness.dark
                    ? Color(0x44FFFFFF)
                    : Color(0x44000000),
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 1.0),
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              ColorGradientWidget(),
              HSLColorChooser(
                currentColor: currentColor,
                hue: hue,
                saturation: saturation,
                lightness: lightness,
                onSave: onSave,
                onChange: onChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HSLColorChooser extends StatefulWidget {
  HSLColorChooser({
    Key? key,
    required this.currentColor,
    required this.hue,
    required this.saturation,
    required this.lightness,
    this.onSave,
    this.onChange,
  }) : super(key: key);

  final Color currentColor;
  final double hue;
  final double saturation;
  final double lightness;
  final ValueChanged<Color>? onSave;
  final ValueChanged<Color>? onChange;

  @override
  _HSLColorChooserState createState() => _HSLColorChooserState();
}

class _HSLColorChooserState extends State<HSLColorChooser> {
  late Color _currentColor;
  late double hue;

  @override
  void initState() {
    super.initState();
    hue = widget.hue;
    _currentColor = HSLColor.fromAHSL(
      1.0,
      widget.hue,
      widget.saturation,
      widget.lightness,
    ).toColor();
  }

  void confirmColor() {
    final Color color = HSLColor.fromAHSL(
      1.0,
      hue,
      widget.saturation,
      widget.lightness,
    ).toColor();
    widget.onSave?.call(color);
  }

  void _onHueSelected(double newHue) {
    setState(() {
      hue = newHue;
      _currentColor = HSLColor.fromAHSL(
        1.0,
        newHue,
        widget.saturation,
        widget.lightness,
      ).toColor();
      widget.onChange?.call(_currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: TurnGestureDetector(
        currentValue: hue,
        maxValue: 360.0,
        onChanged: _onHueSelected,
        child: Stack(
          children: <Widget>[
            ColorPickerDial(
              hue: hue,
              color: _currentColor,
              ratio: 0.96,
              dialRatio: 0.09,
            ),
            HSLColorKnob(
              hue: hue,
              saturation: widget.saturation,
              lightness: widget.lightness,
              ratio: 0.75,
              saveColor: confirmColor,
            ),
          ],
        ),
      ),
    );
  }
}
