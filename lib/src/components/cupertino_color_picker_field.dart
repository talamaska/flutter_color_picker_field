import 'dart:async';

import 'package:color_picker_field/src/models/color_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/animated_color_list_model.dart';
import '../models/color_dialog_model.dart';
import '../models/color_editing_value.dart';
import '../screens/cupertino_color_dialog.dart';
import 'color_item.dart';
import 'color_picker_controllers.dart';
import 'editable_color_picker_field.dart';

const TextStyle _kDefaultPlaceholderStyle = TextStyle(
  fontWeight: FontWeight.w400,
  color: CupertinoColors.placeholderText,
);

// Value inspected from Xcode 11 & iOS 13.0 Simulator.
const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

const Color _kDisabledBackground = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFAFAFA),
  darkColor: Color(0xFF050505),
);

// Value inspected from Xcode 12 & iOS 14.0 Simulator.
// Note it may not be consistent with https://developer.apple.com/design/resources/.
const CupertinoDynamicColor _kClearButtonColor =
    CupertinoDynamicColor.withBrightness(
  color: Color(0x33000000),
  darkColor: Color(0x33FFFFFF),
);

class CupertinoColorPickerField extends StatefulWidget {
  const CupertinoColorPickerField({
    Key? key,
    this.focusNode,
    this.colorListReversed = false,
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.padding = const EdgeInsets.all(6.0),
    required this.defaultColor,
    this.readOnly = false,
    this.colors = const <Color>[],
    this.onChanged,
    this.onSubmitted,
    this.enabled,
    this.style,
    this.scrollPhysics,
    this.scrollController,
    this.maxColors,
    this.controller,
    this.restorationId,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.placeholderStyle = _kDefaultPlaceholderStyle,
    this.clearButtonMode = ClearButtonVisibilityMode.never,
    this.enableLightness = false,
    this.enableSaturation = false,
  }) : super(key: key);

  const CupertinoColorPickerField.borderless({
    Key? key,
    this.focusNode,
    this.decoration,
    this.colorListReversed = false,
    this.padding = const EdgeInsets.all(6.0),
    required this.defaultColor,
    this.readOnly = false,
    this.colors = const <Color>[],
    this.onChanged,
    this.onSubmitted,
    this.enabled,
    this.style,
    this.scrollPhysics,
    this.scrollController,
    this.maxColors,
    this.controller,
    this.restorationId,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.placeholderStyle = _kDefaultPlaceholderStyle,
    this.clearButtonMode = ClearButtonVisibilityMode.never,
    this.enableLightness = false,
    this.enableSaturation = false,
  }) : super(key: key);

  final FocusNode? focusNode;

  /// Controls the [BoxDecoration] of the box behind the text input.
  ///
  /// Defaults to having a rounded rectangle grey border and can be null to have
  /// no box decoration.
  final BoxDecoration? decoration;

  /// Padding around the text entry area between the [prefix] and [suffix]
  /// or the clear button when [clearButtonMode] is not never.
  ///
  /// Defaults to a padding of 6 pixels on all sides and can be null.
  final EdgeInsetsGeometry padding;

  /// A lighter colored placeholder hint that appears on the first line of the
  /// text field when the text entry is empty.
  ///
  /// Defaults to having no placeholder text.
  ///
  /// The text style of the placeholder text matches that of the text field's
  /// main text entry except a lighter font weight and a grey font color.
  final String? placeholder;

  /// The style to use for the placeholder text.
  ///
  /// The [placeholderStyle] is merged with the [style] [TextStyle] when applied
  /// to the [placeholder] text. To avoid merging with [style], specify
  /// [TextStyle.inherit] as false.
  ///
  /// Defaults to the [style] property with w300 font weight and grey color.
  ///
  /// If specifically set to null, placeholder's style will be the same as [style].
  final TextStyle? placeholderStyle;

  /// Required. Controls the default color of the color picker launched from the field.
  final Color defaultColor;

  /// Controls of the color picker field is read only, defaults to false
  final bool readOnly;

  /// An initial list of colors, if not passed, default to an empty list
  final List<Color> colors;

  final ValueChanged<List<Color>>? onChanged;

  /// A callback triggered everytime a color was added or removed to/from the field
  final ValueChanged<List<Color>>? onSubmitted;

  /// Controls if the color picker field is enabled, default to true
  final bool? enabled;

  /// Controls the text align of the placeholder
  final TextAlign textAlign;

  /// Controls if the color list appears reversed, use with caution as it will override the [Directionality]
  final bool colorListReversed;

  /// This text style is used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// If null, defaults to default for the platform scroll physics.
  /// Responsible for the scroll physics of the horizontal animated colors list in the field
  final ScrollPhysics? scrollPhysics;

  /// Responsible for controlling the horizontal animated colors list in the field
  final ScrollController? scrollController;

  /// If [maxColors] is set to this value, only the "current colors number"
  /// part of the colors counter is shown.
  final int? maxColors;

  /// Provides a way to listen for colors list changes
  /// Controls the colors being edited.
  ///
  /// If null, this widget will create its own [ColorPickerFieldController].
  final ColorPickerFieldController? controller;

  /// Defaults to never appearing and cannot be null.
  final ClearButtonVisibilityMode clearButtonMode;

  /// Restoration ID to save and restore the state of the color picker field.
  ///
  /// If no [controller] has been provided - the content of the
  /// color picker field will persist and will be restored.
  /// If a [controller] has been provided, it is the responsibility
  /// of the owner of that controller to persist and restore it, e.g. by using
  /// a [RestorableColorPickerFieldController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

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
  _CupertinoColorPickerFieldState createState() =>
      _CupertinoColorPickerFieldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties
        .add(DiagnosticsProperty<BoxDecoration?>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('placeholder', placeholder));
    properties.add(
        DiagnosticsProperty<TextStyle?>('placeholderStyle', placeholderStyle));
    properties.add(ColorProperty('defaultColor', defaultColor));
    properties.add(DiagnosticsProperty<bool>('readOnly', readOnly));
    properties.add(IterableProperty<Color>('colors', colors));
    properties.add(ObjectFlagProperty<ValueChanged<List<Color>>?>.has(
        'onChanged', onChanged));
    properties.add(ObjectFlagProperty<ValueChanged<List<Color>>?>.has(
        'onSubmitted', onSubmitted));
    properties.add(DiagnosticsProperty<bool?>('enabled', enabled));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties
        .add(DiagnosticsProperty<bool>('colorListReversed', colorListReversed));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics));
    properties.add(DiagnosticsProperty<ScrollController?>(
        'scrollController', scrollController));
    properties.add(IntProperty('maxColors', maxColors));
    properties.add(DiagnosticsProperty<ColorPickerFieldController?>(
        'controller', controller));
    properties.add(EnumProperty<ClearButtonVisibilityMode>(
        'clearButtonMode', clearButtonMode));
    properties.add(StringProperty('restorationId', restorationId));
  }
}

class _CupertinoColorPickerFieldState extends State<CupertinoColorPickerField>
    with
        RestorationMixin,
        AutomaticKeepAliveClientMixin<CupertinoColorPickerField> {
  final GlobalKey _clearGlobalKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListModel<Color> _colorListAnimated;

  RestorableColorPickerFieldController? _controller;
  ColorPickerFieldController get _effectiveController =>
      widget.controller ?? _controller!.value;
  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    }
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
    _colorListAnimated = AnimatedListModel<Color>(
      listKey: _listKey,
      initialItems: widget.colors,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
  }

  @override
  void didUpdateWidget(CupertinoColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
    _controller!.value.addListener(updateKeepAlive);
  }

  void _createLocalController([ColorEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableColorPickerFieldController()
        : RestorableColorPickerFieldController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  bool get isEmpty => _colorListAnimated.isNotEmpty;

  @override
  bool get wantKeepAlive => _controller?.value.colors.isNotEmpty == true;

  bool _shouldShowAttachment({
    required ClearButtonVisibilityMode attachment,
    required bool hasValue,
  }) {
    switch (attachment) {
      case ClearButtonVisibilityMode.never:
        return false;
      case ClearButtonVisibilityMode.always:
        return true;
      case ClearButtonVisibilityMode.hasValue:
        return hasValue;
    }
  }

  bool _showClearButton(ColorEditingValue value) {
    return _shouldShowAttachment(
      attachment: widget.clearButtonMode,
      hasValue: value.colors.isNotEmpty,
    );
  }

  // True if any surrounding decoration widgets will be shown.
  bool get _hasDecoration {
    return widget.placeholder != null ||
        widget.clearButtonMode != ClearButtonVisibilityMode.never;
  }

  Widget _buildRemovedItem(
    BuildContext context,
    Color item,
    Animation<double> animation,
  ) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);

    final TextStyle? resolvedStyle = widget.style?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(widget.style?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.style?.backgroundColor, context),
    );

    final TextStyle textStyle =
        themeData.textTheme.textStyle.merge(resolvedStyle);

    final TextStyle? resolvedPlaceholderStyle =
        widget.placeholderStyle?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.backgroundColor, context),
    );

    final TextStyle placeholderStyle =
        textStyle.merge(resolvedPlaceholderStyle);
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.elasticIn,
      ),
      child: ColorItem(
        size: placeholderStyle.fontSize,
        item: item,
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);

    final TextStyle? resolvedStyle = widget.style?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(widget.style?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.style?.backgroundColor, context),
    );

    final TextStyle textStyle =
        themeData.textTheme.textStyle.merge(resolvedStyle);

    final TextStyle? resolvedPlaceholderStyle =
        widget.placeholderStyle?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.backgroundColor, context),
    );

    final TextStyle placeholderStyle =
        textStyle.merge(resolvedPlaceholderStyle);

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: ColorItem(
        size: placeholderStyle.fontSize,
        item: _colorListAnimated[index],
      ),
    );
  }

  Widget _addTextDependentAttachments(
      Widget editableColors, TextStyle textStyle, TextStyle placeholderStyle) {
    // If there are no surrounding widgets, just return the core editable text
    // part.
    if (!_hasDecoration) {
      return editableColors;
    }

    // Otherwise, listen to the current state of the colors entry.
    return ValueListenableBuilder<ColorEditingValue>(
      valueListenable: _effectiveController,
      child: editableColors,
      builder: (BuildContext context, ColorEditingValue value, Widget? child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (widget.placeholder != null && value.colors.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: widget.padding,
                        child: Text(
                          widget.placeholder!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: placeholderStyle,
                          textAlign: widget.textAlign,
                        ),
                      ),
                    ),
                  child!,
                ],
              ),
            ),

            // Otherwise, try to show a clear button if its visibility mode matches.
            if (_showClearButton(value))
              GestureDetector(
                key: _clearGlobalKey,
                onTap: widget.enabled ?? true
                    ? () {
                        // Special handle onChanged for ClearButton
                        // Also call onChanged when the clear button is tapped.
                        final bool colorsChanged =
                            _effectiveController.colors.isNotEmpty;
                        _effectiveController.clear();
                        _colorListAnimated.clear();
                        if (widget.onChanged != null && colorsChanged) {
                          widget.onChanged!(_effectiveController.colors);
                        }
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(
                    CupertinoIcons.clear_thick_circled,
                    size: 18.0,
                    color: CupertinoDynamicColor.resolve(
                        _kClearButtonColor, context),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ColorPickerFieldController controller = _effectiveController;
    final bool enabled = widget.enabled ?? true;

    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final FocusNode focusNode = _effectiveFocusNode;

    final TextStyle? resolvedStyle = widget.style?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(widget.style?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.style?.backgroundColor, context),
    );

    final TextStyle textStyle =
        themeData.textTheme.textStyle.merge(resolvedStyle);

    final TextStyle? resolvedPlaceholderStyle =
        widget.placeholderStyle?.copyWith(
      color: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.color, context),
      backgroundColor: CupertinoDynamicColor.maybeResolve(
          widget.placeholderStyle?.backgroundColor, context),
    );

    final TextStyle placeholderStyle =
        textStyle.merge(resolvedPlaceholderStyle);
    final Color disabledColor =
        CupertinoDynamicColor.resolve(_kDisabledBackground, context);
    final Color? decorationColor =
        CupertinoDynamicColor.maybeResolve(widget.decoration?.color, context);
    final BoxBorder? border = widget.decoration?.border;
    Border? resolvedBorder = border as Border?;

    final TextDirection textDirection = Directionality.of(context);

    if (border is Border) {
      BorderSide resolveBorderSide(BorderSide side) {
        return side == BorderSide.none
            ? side
            : side.copyWith(
                color: CupertinoDynamicColor.resolve(side.color, context));
      }

      resolvedBorder = border == null || border.runtimeType != Border
          ? border
          : Border(
              top: resolveBorderSide(border.top),
              left: resolveBorderSide(border.left),
              bottom: resolveBorderSide(border.bottom),
              right: resolveBorderSide(border.right),
            );
    }

    final BoxDecoration? effectiveDecoration = widget.decoration?.copyWith(
      border: resolvedBorder,
      color: enabled ? decorationColor : disabledColor,
    );

    final Widget paddedEditable = Padding(
      padding: widget.padding,
      child: RepaintBoundary(
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: EditableColorPickerField(
              listKey: _listKey,
              colorList: _colorListAnimated,
              controller: controller,
              focusNode: focusNode,
              itemBuilder: _buildItem,
              style: textStyle,
              colorListReversed: widget.colorListReversed,
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: !enabled || widget.readOnly
          ? null
          : () {
              _handleFocus();
              _openAddEntryDialog(
                controller,
                textDirection,
                effectiveDecoration,
              );
            },
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          decoration: effectiveDecoration,
          color: !enabled && effectiveDecoration == null ? disabledColor : null,
          child: Align(
            alignment: Alignment(-1.0, TextAlignVertical.center.y),
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: _addTextDependentAttachments(
              paddedEditable,
              textStyle,
              placeholderStyle,
            ),
          ),
        ),
      ),
    );
  }

  void _handleFocus() {
    if (!_effectiveFocusNode.hasFocus && _effectiveFocusNode.canRequestFocus) {
      _effectiveFocusNode.requestFocus();
    }
  }

  Future<void> _openAddEntryDialog(
    ColorPickerFieldController controller,
    TextDirection textDirection,
    BoxDecoration? decoration,
  ) async {
    final CupertinoDialogRoute<ColorPickerDialogModel> dialog =
        CupertinoDialogRoute<ColorPickerDialogModel>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoColorPickerDialog(
          initialColor: widget.defaultColor,
          colorList: _colorListAnimated.items,
          textDirection: textDirection,
          decoration: decoration,
          enableLightness: widget.enableLightness,
          enableSaturation: widget.enableSaturation,
        );
      },
    );

    await Navigator.of(context).push(dialog);

    dialog.completed.then((ColorPickerDialogModel? value) {
      if (value != null) {
        _updateColors(value, controller);
      }

      if (_effectiveFocusNode.hasFocus && _colorListAnimated.isEmpty) {
        _effectiveFocusNode.unfocus();
      }
    });
    // showDialog<ColorPickerDialogModel>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return ColorPickerDialog(
    //         initialColor: widget.defaultColor,
    //         colorList: _colorListAnimated.items,
    //         textDirection: textDirection,
    //       );
    //     }).then((ColorPickerDialogModel? value) {
    //   if (value != null) {
    //     _updateColors(value, controller);
    //   }

    //   if (_effectiveFocusNode.hasFocus && _colorListAnimated.isEmpty) {
    //     _effectiveFocusNode.unfocus();
    //   }
    // });
  }

  void _updateColors(
    ColorPickerDialogModel value,
    ColorPickerFieldController controller,
  ) {
    final int atLeastOnetoBeRemovedIndex =
        value.colorStates.indexWhere((ColorState element) => !element.selected);
    if (atLeastOnetoBeRemovedIndex != -1) {
      for (int i = 0; i < value.colorStates.length; i++) {
        if (!value.colorStates[i].selected) {
          final int index =
              _colorListAnimated.indexOf(value.colorStates[i].color);
          if (index != -1) {
            _colorListAnimated.removeAt(index);
          }
        }
      }
    }

    if (value.color != null) {
      if (!_colorListAnimated.contains(value.color!)) {
        _colorListAnimated.insert(_colorListAnimated.length, value.color!);
      }
    }

    controller.value =
        ColorEditingValue(colors: List<Color>.from(_colorListAnimated.items));
  }
}

enum ClearButtonVisibilityMode {
  /// Overlay will never appear regardless of the text entry state.
  never,

  /// Overlay will appear when there are colors in the field
  hasValue,

  /// Always show the overlay regardless of the text entry state.
  always,
}
