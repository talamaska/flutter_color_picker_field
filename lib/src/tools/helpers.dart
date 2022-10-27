import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isCupertino(BuildContext context) {
  final CupertinoThemeData ct = CupertinoTheme.of(context);

  return ct is! MaterialBasedCupertinoThemeData;
}

double extractHue(Color color) {
  final HSLColor hslColor = HSLColor.fromColor(color);
  final double hue = hslColor.hue;
  return hue;
}
