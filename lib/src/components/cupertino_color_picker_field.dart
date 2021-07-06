import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../color_picker_field.dart';
import 'color_item.dart';
import 'color_picker_controllers.dart';
import 'editable_color_picker_field.dart';
import '../models/color_editing_value.dart';
import '../models/animated_color_list_model.dart';
import '../models/color_dialog_model.dart';

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
    this.autofocus = false,
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
    this.maxLength,
    this.controller,
    this.restorationId,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.placeholderStyle = _kDefaultPlaceholderStyle,
    this.clearButtonMode = ClearButtonVisibilityMode.never,
  }) : super(key: key);

  const CupertinoColorPickerField.borderless({
    Key? key,
    this.autofocus = false,
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
    this.maxLength,
    this.controller,
    this.restorationId,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.placeholderStyle = _kDefaultPlaceholderStyle,
    this.clearButtonMode = ClearButtonVisibilityMode.never,
  });

  final FocusNode? focusNode;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry padding;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Color defaultColor;
  final bool readOnly;
  final bool autofocus;
  final List<Color> colors;
  final ValueChanged<List<Color>>? onChanged;
  final ValueChanged<List<Color>>? onSubmitted;
  final bool? enabled;
  final TextAlign textAlign;
  final bool colorListReversed;

  /// This text style is used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;

  final int? maxLength;
  final ColorPickerFieldController? controller;
  final ClearButtonVisibilityMode clearButtonMode;

  final String? restorationId;

  @override
  _CupertinoColorPickerFieldState createState() =>
      _CupertinoColorPickerFieldState();
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

  get isEmpty => _colorListAnimated.isNotEmpty;

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
                        if (widget.onChanged != null && colorsChanged)
                          widget.onChanged!(_effectiveController.colors);
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
              _openAddEntryDialog(controller, textDirection);
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
  ) async {
    final CupertinoDialogRoute<ColorPickerDialogModel> dialog =
        CupertinoDialogRoute<ColorPickerDialogModel>(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(
          initialColor: widget.defaultColor,
          colorList: _colorListAnimated.items,
          textDirection: textDirection,
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
        value.colorStates.indexWhere((element) => !element.selected);
    if (atLeastOnetoBeRemovedIndex != -1) {
      for (var i = 0; i < value.colorStates.length; i++) {
        if (!value.colorStates[i].selected) {
          var index = _colorListAnimated.indexOf(value.colorStates[i].color);
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
        ColorEditingValue(colors: List.from(_colorListAnimated.items));
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
