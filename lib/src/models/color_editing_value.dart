import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class ColorEditingValue {
  const ColorEditingValue({
    this.colors = const <Color>[],
  });

  final List<Color> colors;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'colors': colors.map((Color x) => x.value).toList(),
    };
  }

  factory ColorEditingValue.fromMap(Map<String, dynamic> map) {
    final List<Color> colorsList = (map['colors'] as List<int>)
        .map<Color>((int x) => Color(x)) as List<Color>;
    return ColorEditingValue(
      colors: List<Color>.from(colorsList),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorEditingValue.fromJson(String source) =>
      ColorEditingValue.fromMap(json.decode(source) as Map<String, dynamic>);

  static const ColorEditingValue empty = ColorEditingValue();

  ColorEditingValue copyWith({
    List<Color>? colors,
  }) {
    return ColorEditingValue(
      colors: colors ?? this.colors,
    );
  }

  @override
  String toString() => 'ColorEditingValue(colors: $colors)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorEditingValue &&
        listEquals<Color>(other.colors, colors);
  }

  @override
  int get hashCode => colors.hashCode;
}
