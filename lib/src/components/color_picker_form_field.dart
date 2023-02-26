import 'package:flutter/material.dart';

import '../components/color_picker_controllers.dart';
import '../components/color_picker_field.dart';
import '../models/color_editing_value.dart';

typedef SelectionChangeCallback = void Function(bool selected, Color color);

typedef SelectedColorItemBuilder = Widget Function(
  Color color,
  bool selected,
  SelectionChangeCallback onSelectionChange,
);

class ColorPickerFormField extends FormField<List<Color>> {
  ColorPickerFormField({
    Key? key,
    FocusNode? focusNode,
    FormFieldSetter<List<Color>>? onSaved,
    FormFieldValidator<List<Color>>? validator,
    List<Color>? initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    TextStyle? style,
    bool colorListReversed = false,
    InputDecoration? decoration,
    ValueChanged<String>? onFieldSubmitted,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    bool? enabled,
    int? maxColors,
    InputCounterWidgetBuilder? buildCounter,
    bool readOnly = false,
    this.onChanged,
    required this.defaultColor,
    this.controller,
    this.enableLightness = false,
    this.enableSaturation = false,
    this.selectedColorItemBuilder,
  })  : assert(initialValue == null || controller == null),
        assert(maxColors == null || maxColors > 0),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: controller != null
                ? controller.value.colors
                : (initialValue ?? <Color>[]),
            autovalidateMode: autovalidateMode,
            enabled: enabled ?? decoration?.enabled ?? true,
            builder: (FormFieldState<List<Color>> field) {
              final _ColorPickerFormFieldState state =
                  field as _ColorPickerFormFieldState;
              final InputDecoration effectiveDecoration = (decoration ??
                      const InputDecoration())
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);

              void onChangedHandler(List<Color> value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              return ColorPickerField(
                  controller: state._effectiveController,
                  focusNode: focusNode,
                  style: style,
                  colorListReversed: colorListReversed,
                  readOnly: readOnly,
                  maxColors: maxColors,
                  enabled: enabled ?? decoration?.enabled ?? true,
                  buildCounter: buildCounter,
                  scrollController: scrollController,
                  scrollPhysics: scrollPhysics,
                  onSubmitted: onFieldSubmitted,
                  defaultColor: defaultColor,
                  colors: controller != null
                      ? controller.value.colors
                      : (initialValue ?? <Color>[]),
                  onChanged: onChangedHandler,
                  decoration: effectiveDecoration.copyWith(
                    errorText: field.errorText,
                  ),
                  enableLightness: enableLightness,
                  enableSaturation: enableSaturation,
                  selectedColorItemBuilder: selectedColorItemBuilder);
            });

  /// You can provide a custom widget for the selected colors list
  final SelectedColorItemBuilder? selectedColorItemBuilder;

  /// Enable the saturation control for the color value.
  ///
  /// Set to true to allow users to control the saturation value of the
  /// selected color. The displayed Saturation value on the slider goes from 0%,
  /// which is totally unsaturated, to 100%, which if fully saturated.
  ///
  /// Defaults to false.
  final bool enableSaturation;

  /// Enable the lightness control for the color value.
  ///
  /// Set to true to allow users to control the lightness value of the
  /// selected color. The displayed lightness value on the slider goes from 0%,
  /// which is totally black, to 100%, which if fully white.
  ///
  /// Defaults to false.
  final bool enableLightness;

  final ValueChanged<List<Color>>? onChanged;
  final Color defaultColor;
  final ColorPickerFieldController? controller;

  @override
  FormFieldState<List<Color>> createState() => _ColorPickerFormFieldState();
}

class _ColorPickerFormFieldState extends FormFieldState<List<Color>> {
  ColorPickerFieldController? _controller;

  ColorPickerFieldController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  ColorPickerFormField get widget => super.widget as ColorPickerFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = ColorPickerFieldController(colors: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(ColorPickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            ColorPickerFieldController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.value.colors);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(List<Color>? value) {
    super.didChange(value);

    if (_effectiveController!.value.colors != value) {
      _effectiveController!.value = value != null
          ? ColorEditingValue(colors: value)
          : ColorEditingValue.empty;
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController!.value = widget.initialValue == null
        ? ColorEditingValue.empty
        : ColorEditingValue(colors: widget.initialValue!);
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.colors != value) {
      didChange(_effectiveController!.colors);
    }
  }
}
