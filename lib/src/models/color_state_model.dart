import 'dart:convert';

import 'package:flutter/material.dart';

class ColorState {
  const ColorState({
    required this.color,
    required this.selected,
  });

  final Color color;
  final bool selected;

  ColorState copyWith({
    Color? color,
    bool? selected,
  }) {
    return ColorState(
      color: color ?? this.color,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color.value,
      'selected': selected,
    };
  }

  factory ColorState.fromMap(Map<String, dynamic> map) {
    return ColorState(
      color: Color(map['color'] as int),
      selected: map['selected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorState.fromJson(String source) =>
      ColorState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ColorState(color: $color, selected: $selected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorState &&
        other.color == color &&
        other.selected == selected;
  }

  @override
  int get hashCode => color.hashCode ^ selected.hashCode;
}
