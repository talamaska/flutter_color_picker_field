import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class ColorPickerDial extends StatefulWidget {
  const ColorPickerDial({
    Key? key,
    required this.hue,
    required this.ratio,
    required this.dialRatio,
    required this.color,
  }) : super(key: key);

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
      angle: radians(widget.hue),
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
