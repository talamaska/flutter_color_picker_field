import 'package:flutter/material.dart';

class ColoredCheckbox extends StatelessWidget {

  const ColoredCheckbox({
    this.color,
    this.state
  });

  final Color color;
  final bool state;


  @override
  Widget build(BuildContext context) {
    return Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
            border: Border.all(style: BorderStyle.solid, color: color, width: 1.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: color,
                  offset: const Offset(0.0, 0.0),
                  spreadRadius: state ? 1.0 : 0.0,
                  blurRadius: state ? 2.0 : 0.0
              )
            ],
            shape: BoxShape.circle,
            color: state ? color : Colors.white
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 34.0,
        )
    );
  }
}
