import 'package:flutter/material.dart';
import '../models/color_state_model.dart';

class ColorPickerDialogModel {
  const ColorPickerDialogModel({
    this.color,
    required this.colorStates,
  });

  final Color? color;
  final List<ColorState> colorStates;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPickerDialogModel &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          colorStates == other.colorStates;

  @override
  int get hashCode => color.hashCode ^ colorStates.hashCode;

  @override
  String toString() {
    return 'ColorDialogModel(color: $color, colorStates: $colorStates)';
  }
}
