import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_picker/tools/helpers.dart';

class ColoredCheckbox extends StatelessWidget {
  const ColoredCheckbox({
    this.color,
    this.state,
  });

  final Color color;
  final bool state;

  @override
  Widget build(BuildContext context) {
    final IconData checkboxIcon =
        isCupertino(context) ? CupertinoIcons.check_mark : Icons.check;

    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          color: color,
          width: 1.0,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color,
            offset: const Offset(0.0, 0.0),
            spreadRadius: state ? 1.0 : 0.0,
            blurRadius: state ? 2.0 : 0.0,
          )
        ],
        shape: BoxShape.circle,
        color: state ? color : Color(0xFFFFFFFF),
      ),
      child: const Icon(
        Icons.check,
        color: Color(0xFFFFFFFF),
        size: 34.0,
      ),
    );
  }
}
