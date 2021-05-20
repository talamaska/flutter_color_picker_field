import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_picker/tools/helpers.dart';

class ColoredCheckbox extends StatefulWidget {
  const ColoredCheckbox({
    required this.color,
    this.value = false,
    this.onChanged,
  });

  final Color color;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  _ColoredCheckboxState createState() => _ColoredCheckboxState();
}

class _ColoredCheckboxState extends State<ColoredCheckbox> {
  bool get enabled => widget.onChanged != null;

  void _actionHandler() {
    switch (widget.value) {
      case false:
        widget.onChanged?.call(true);
        break;
      case true:
        widget.onChanged?.call(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData checkboxIcon =
        isCupertino(context) ? CupertinoIcons.check_mark : Icons.check;

    return GestureDetector(
      onTap: _actionHandler,
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
            color: widget.color,
            width: 1.0,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: widget.color,
              offset: const Offset(0.0, 0.0),
              spreadRadius: widget.value! ? 1.0 : 0.0,
              blurRadius: widget.value! ? 2.0 : 0.0,
            )
          ],
          shape: BoxShape.circle,
          color: widget.value! ? widget.color : Color(0xFFFFFFFF),
        ),
        child: Icon(
          checkboxIcon,
          color: Color(0xFFFFFFFF),
          size: 34.0,
        ),
      ),
    );
  }
}
