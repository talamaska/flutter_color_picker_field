import 'dart:core';

import 'package:flutter/widgets.dart';

import 'color_gradient_widget.dart';
import '../tools/helpers.dart';
import '../components/color_knob.dart';
import '../components/color_picker_dial.dart';
import '../components/turn_gesture_detector.dart';

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
    return Container(
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

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor;
  }

  void confirmColor() {
    widget.onSave?.call(_currentColor);
  }

  void _onHueSelected(double newHue) {
    setState(() {
      _currentColor = HSLColor.fromAHSL(1.0, newHue, 1.0, 0.5).toColor();
      widget.onChange?.call(_currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: TurnGestureDetector(
        currentValue: extractHue(_currentColor),
        maxValue: 360.0,
        onChanged: _onHueSelected,
        child: Stack(
          children: <Widget>[
            ColorPickerDial(
              hue: extractHue(_currentColor),
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
    );
  }
}
