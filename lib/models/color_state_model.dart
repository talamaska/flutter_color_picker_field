import 'package:flutter/material.dart';

class ColorState {
  const ColorState({
    this.color,
    this.state
  });
  final Color color;
  final bool state;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ColorState &&
              runtimeType == other.runtimeType &&
              color == other.color &&
              state == other.state;

  //New
  @override
  int get hashCode =>
      color.hashCode ^ state.hashCode;

  @override
  String toString() {
    return 'ColorState{color: $color, state: $state}';
  }
}