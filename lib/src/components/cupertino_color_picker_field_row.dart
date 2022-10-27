// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import '../models/color_editing_value.dart';
import 'color_picker_controllers.dart';
import 'cupertino_color_picker_field.dart';

/// Creates a [CupertinoFormRow] containing a [FormField] that wraps
/// a [CupertinoColorPickerField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// When a [controller] is specified, its [ColorPickerFieldController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// The [prefix] parameter is displayed at the start of the row. Standard iOS
/// guidelines encourage passing a [Text] widget to [prefix] to detail the
/// nature of the input.
///
/// The [padding] parameter is used to pad the contents of the row. It is
/// directly passed to [CupertinoFormRow]. If the [padding]
/// parameter is null, [CupertinoFormRow] constructs its own default
/// padding (which is the standard form row padding in iOS.) If no edge
/// insets are intended, explicitly pass [EdgeInsets.zero] to [padding].
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Consider calling [ColorPickerFieldController.dispose] of the [controller], if one
/// is specified, when it is no longer needed. This will ensure we discard any
/// resources used by the object.
///
/// For documentation about the various parameters, see the
/// [CupertinoColorPickerField] class and [new CupertinoColorPickerField.borderless],
/// the constructor.
///
/// {@tool snippet}
///
/// Creates a [CupertinoColorPickerFormFieldRow] with a leading text and validator
/// function.
///
/// If the user enters valid text, the CupertinoColorPickerField appears normally
/// without any warnings to the user.
///
/// If the user enters invalid text, the error message returned from the
/// validator function is displayed in dark red underneath the input.
///
/// ```dart
/// CupertinoColorPickerFormFieldRow(
///   prefix: const Text('Username'),
///   onSaved: (String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String? value) {
///     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateful_widget_material}
/// This example shows how to move the focus to the next field when the user
/// presses the SPACE key.
///
/// ```dart imports
/// import 'package:flutter/cupertino.dart';
/// ```
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return CupertinoPageScaffold(
///     child: Center(
///       child: Form(
///         autovalidateMode: AutovalidateMode.always,
///         onChanged: () {
///           Form.of(primaryFocus!.context!)?.save();
///         },
///         child: CupertinoFormSection.insetGrouped(
///           header: const Text('SECTION 1'),
///           children: List<Widget>.generate(5, (int index) {
///             return CupertinoColorPickerFormFieldRow(
///               prefix: const Text('Enter text'),
///               placeholder: 'Enter text',
///               validator: (String? value) {
///                 if (value == null || value.isEmpty) {
///                   return 'Please enter a value';
///                 }
///                 return null;
///               },
///             );
///          }),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
class CupertinoColorPickerFormFieldRow extends FormField<List<Color>> {
  /// Creates a [CupertinoFormRow] containing a [FormField] that wraps
  /// a [CupertinoColorPickerField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [ColorPickerFieldController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// The [prefix] parameter is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the input.
  ///
  /// The [padding] parameter is used to pad the contents of the row. It is
  /// directly passed to [CupertinoFormRow]. If the [padding]
  /// parameter is null, [CupertinoFormRow] constructs its own default
  /// padding (which is the standard form row padding in iOS.) If no edge
  /// insets are intended, explicitly pass [EdgeInsets.zero] to [padding].
  ///
  /// For documentation about the various parameters, see the
  /// [CupertinoColorPickerField] class and [new CupertinoColorPickerField.borderless],
  /// the constructor.
  CupertinoColorPickerFormFieldRow({
    Key? key,
    this.prefix,
    this.padding,
    this.controller,
    required this.defaultColor,
    List<Color>? initialValue,
    FocusNode? focusNode,
    BoxDecoration? decoration,
    TextStyle? style,
    ClearButtonVisibilityMode clearButtonMode = ClearButtonVisibilityMode.never,
    TextAlign textAlign = TextAlign.start,
    bool readOnly = false,
    int? maxLength,
    ValueChanged<List<Color>>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<List<Color>>? onFieldSubmitted,
    FormFieldSetter<List<Color>>? onSaved,
    FormFieldValidator<List<Color>>? validator,
    bool? enabled,
    ScrollPhysics? scrollPhysics,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool colorListReversed = false,
    String? placeholder,
    TextStyle? placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    this.enableLightness = false,
    this.enableSaturation = false,
  })  : assert(initialValue == null || controller == null),
        super(
          key: key,
          initialValue: controller?.colors ?? initialValue ?? <Color>[],
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<List<Color>> field) {
            final _CupertinoColorPickerFormFieldRowState state =
                field as _CupertinoColorPickerFormFieldRowState;

            void onChangedHandler(List<Color> value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return CupertinoFormRow(
              prefix: prefix,
              padding: padding,
              error: (field.errorText == null) ? null : Text(field.errorText!),
              child: CupertinoColorPickerField.borderless(
                controller: state._effectiveController,
                defaultColor: defaultColor,
                focusNode: focusNode,
                clearButtonMode: clearButtonMode,
                decoration: decoration,
                style: style,
                readOnly: readOnly,
                maxColors: maxLength,
                onChanged: onChangedHandler,
                onSubmitted: onFieldSubmitted,
                enabled: enabled,
                scrollPhysics: scrollPhysics,
                placeholder: placeholder,
                placeholderStyle: placeholderStyle,
                colorListReversed: colorListReversed,
                enableLightness: enableLightness,
                enableSaturation: enableSaturation,
              ),
            );
          },
        );

  /// A widget that is displayed at the start of the row.
  ///
  /// The [prefix] widget is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the input.
  final Widget? prefix;

  /// Content padding for the row.
  ///
  /// The [padding] widget is passed to [CupertinoFormRow]. If the [padding]
  /// parameter is null, [CupertinoFormRow] constructs its own default
  /// padding, which is the standard form row padding in iOS.
  ///
  /// If no edge insets are intended, explicitly pass [EdgeInsets.zero] to
  /// [padding].
  final EdgeInsetsGeometry? padding;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [ColorPickerFieldController] and
  /// initialize its [ColorPickerFieldController.text] with [initialValue].
  final ColorPickerFieldController? controller;

  final Color defaultColor;

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

  @override
  FormFieldState<List<Color>> createState() =>
      _CupertinoColorPickerFormFieldRowState();
}

class _CupertinoColorPickerFormFieldRowState
    extends FormFieldState<List<Color>> {
  ColorPickerFieldController? _controller;

  ColorPickerFieldController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  CupertinoColorPickerFormFieldRow get widget =>
      super.widget as CupertinoColorPickerFormFieldRow;

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
  void didUpdateWidget(CupertinoColorPickerFormFieldRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            ColorPickerFieldController.fromValue(oldWidget.controller!.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller!.colors);
        if (oldWidget.controller == null) {
          _controller = null;
        }
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
      if (value != null) {
        _effectiveController!.value = ColorEditingValue(colors: value);
      } else {
        _effectiveController!.value = ColorEditingValue.empty;
      }
    }
  }

  @override
  void reset() {
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
