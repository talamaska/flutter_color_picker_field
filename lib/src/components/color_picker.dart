import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'color_gradient_widget.dart';
import '../tools/helpers.dart';
import 'color_picker_dial.dart';
import 'turn_gesture_detector.dart';
import 'hsl_color_knob.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    required this.currentColor,
    this.onSave,
    this.onChange,
  });

  final Color currentColor;
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
              ColorChooser(
                currentColor: currentColor,
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

class ColorChooser extends StatefulWidget {
  ColorChooser({
    Key? key,
    required this.currentColor,
    this.onSave,
    this.onChange,
  }) : super(key: key);

  final Color currentColor;
  final ValueChanged<Color>? onSave;
  final ValueChanged<Color>? onChange;

  @override
  _ColorChooserState createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  late Color _currentColor;
  late double hue;
  late double saturation;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor;
    hue = extractHue(widget.currentColor);
  }

  void confirmColor() {
    widget.onSave?.call(_currentColor);
  }

  void _onHueSelected(double newHue) {
    setState(() {
      hue = newHue;
      _currentColor = HSLColor.fromAHSL(1.0, newHue, 1.0, 0.5).toColor();
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
              saturation: 1.0,
              lightness: 0.5,
              ratio: 0.75,
              saveColor: confirmColor,
            ),
          ],
        ),
      ),
    );
  }
}
