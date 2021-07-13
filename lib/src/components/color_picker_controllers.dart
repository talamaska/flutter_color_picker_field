import 'package:flutter/widgets.dart';
import '../models/color_editing_value.dart';

class RestorableColorPickerFieldController
    extends RestorableChangeNotifier<ColorPickerFieldController> {
  /// Creates a [RestorableTextEditingController].
  ///
  /// This constructor treats a null `text` argument as if it were the empty
  /// string.
  factory RestorableColorPickerFieldController({List<Color>? colors}) =>
      RestorableColorPickerFieldController.fromValue(
        colors == null
            ? ColorEditingValue.empty
            : ColorEditingValue(colors: colors),
      );

  /// Creates a [RestorableTextEditingController] from an initial
  /// [ColorEditingValue].
  ///
  /// This constructor treats a null `value` argument as if it were
  /// [ColorEditingValue.empty].
  RestorableColorPickerFieldController.fromValue(ColorEditingValue value)
      : _initialValue = value;

  final ColorEditingValue _initialValue;

  @override
  ColorPickerFieldController createDefaultValue() {
    return ColorPickerFieldController.fromValue(_initialValue);
  }

  @override
  ColorPickerFieldController fromPrimitives(Object? data) {
    return ColorPickerFieldController(colors: data! as List<Color>);
  }

  @override
  Object toPrimitives() {
    return value.colors;
  }
}

class ColorPickerFieldController extends ValueNotifier<ColorEditingValue> {
  ColorPickerFieldController({List<Color>? colors})
      : super(colors == null
            ? ColorEditingValue.empty
            : ColorEditingValue(colors: colors));

  /// Creates a controller for an editable text field from an initial [ColorEditingValue].
  ///
  /// This constructor treats a null [value] argument as if it were
  /// [ColorEditingValue.empty].
  ColorPickerFieldController.fromValue(ColorEditingValue? value)
      : super(value ?? ColorEditingValue.empty);

  /// The current string the user is editing.
  List<Color> get colors => value.colors;

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this value should only be set between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  ///
  /// This property can be set from a listener added to this
  /// [ColorPickerFieldController]; however, one should not also set [selection]
  /// in a separate statement. To change both the [text] and the [selection]
  /// change the controller's [value].
  set colors(List<Color> newColors) {
    value = value.copyWith(
      colors: newColors,
    );
  }

  @override
  set value(ColorEditingValue newValue) {
    super.value = newValue;
  }

  void clear() {
    value = ColorEditingValue.empty;
  }
}
