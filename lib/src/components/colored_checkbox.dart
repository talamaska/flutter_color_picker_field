import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../tools/helpers.dart';

class ColoredCheckbox extends StatefulWidget {
  const ColoredCheckbox({
    Key? key,
    this.size,
    required this.color,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  final Size? size;
  final Color color;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  _ColoredCheckboxState createState() => _ColoredCheckboxState();
}

class _ColoredCheckboxState extends State<ColoredCheckbox> {
  bool get enabled => widget.onChanged != null;
  Size get size => widget.size ?? const Size(44.0, 44.0);

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
        width: size.width,
        height: size.width,
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
          color: widget.value! ? widget.color : const Color(0xFFFFFFFF),
        ),
        child: Center(
          child: Icon(
            checkboxIcon,
            color: const Color(0xFFFFFFFF),
            size: size.width * 0.8,
          ),
        ),
      ),
    );
  }
}

class ColoredGridCheckbox extends StatefulWidget {
  const ColoredGridCheckbox({
    Key? key,
    required this.color,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  final Color color;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  _ColoredGridCheckboxState createState() => _ColoredGridCheckboxState();
}

class _ColoredGridCheckboxState extends State<ColoredGridCheckbox> {
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
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          color: widget.color,
          width: 1.0,
        ),
        color: widget.value ? widget.color : const Color(0xFFFFFFFF),
      ),
      child: InkWell(
        onTap: _actionHandler,
        child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 16.0,
                width: 16.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: theme.primaryColor,
                    width: 1.0,
                  ),
                  shape: BoxShape.circle,
                  color: widget.value
                      ? theme.primaryColor
                      : const Color(0xFFFFFFFF),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.value ? Icons.check : null,
                  color: theme.colorScheme.onPrimary,
                  size: 14,
                ),
              ),
            )),
      ),
    );
  }
}
