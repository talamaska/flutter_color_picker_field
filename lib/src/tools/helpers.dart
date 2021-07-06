import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

bool isCupertino(BuildContext context) {
  final CupertinoThemeData ct = CupertinoTheme.of(context);
  if (ct == null) {
    return false;
  }

  return ct is! MaterialBasedCupertinoThemeData;
}

double extractHue(Color color) {
  final HSLColor hslColor = HSLColor.fromColor(color);
  final double hue = hslColor.hue;
  return hue;
}
