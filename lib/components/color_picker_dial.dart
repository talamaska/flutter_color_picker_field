import 'package:angles/angles.dart';
import 'package:flutter/material.dart';



class ColorPickerDial extends StatefulWidget {
  const ColorPickerDial({
    this.hue,
    this.ratio,
    this.dialRatio,
    this.color,
//    this.child
  });

  final double hue;
  final double ratio;
  final double dialRatio;
  final Color color;
//  final Widget child;

  @override
  _ColorPickerDialState createState() => _ColorPickerDialState();
}

class _ColorPickerDialState extends State<ColorPickerDial> {


  @override
  Widget build(BuildContext context) {

//    debugPrint('size ${context.size}');

    return Transform.rotate(
      angle: Angle.fromDegrees(widget.hue).radians,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: widget.ratio,
          heightFactor: widget.ratio,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: widget.dialRatio,
                heightFactor: widget.dialRatio,
                child: Container(
//                  width: 25.0,
////                  height: 25.0,

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0x44000000),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 0.0))
                    ]),
                ),
              ),
            ),
          ),
        ),
      ),

    );

  }
}
