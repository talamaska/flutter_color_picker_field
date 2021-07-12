import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../models/color_editing_value.dart';

import '../components/color_item.dart';
import '../components/color_picker_controllers.dart';
import 'editable_color_picker_field.dart';
import '../models/animated_color_list_model.dart';
import '../models/color_dialog_model.dart';
import '../screens/color_dialog.dart';

class ColorPickerField extends StatefulWidget {
  const ColorPickerField({
    Key? key,
    this.autofocus = false,
    this.focusNode,
    this.colorListReversed = false,
    this.decoration = const InputDecoration(),
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
    this.mouseCursor,
    this.restorationId,
    this.buildCounter,
  }) : super(key: key);

  final FocusNode? focusNode;
  final bool colorListReversed;
  final InputDecoration? decoration;
  final Color defaultColor;
  final bool readOnly;
  final bool autofocus;
  final List<Color> colors;
  final ValueChanged<List<Color>>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;

  /// This text style is used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final int? maxColors;
  final ColorPickerFieldController? controller;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.error].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// If this property is null, [MaterialStateMouseCursor.textable] will be used.
  ///
  /// The [mouseCursor] is the only property of [ColorPickerField] that controls the
  /// appearance of the mouse pointer. All other properties related to "cursor"
  /// stand for the text cursor, which is usually a blinking vertical line at
  /// the editing position.
  final MouseCursor? mouseCursor;
  final String? restorationId;

  /// If [maxColors] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// Callback that generates a custom [InputDecoration.counter] widget.
  ///
  /// See [InputCounterWidgetBuilder] for an explanation of the passed in
  /// arguments.  The returned widget will be placed below the line in place of
  /// the default widget built when [InputDecoration.counterText] is specified.
  ///
  /// The returned widget will be wrapped in a [Semantics] widget for
  /// accessibility, but it also needs to be accessible itself. For example,
  /// if returning a Text widget, set the [Text.semanticsLabel] property.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget counter(
  ///   BuildContext context,
  ///   {
  ///     required int currentLength,
  ///     required int? maxLength,
  ///     required bool isFocused,
  ///   }
  /// ) {
  ///   return Text(
  ///     '$currentLength of $maxLength characters',
  ///     semanticsLabel: 'character count',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// If buildCounter returns null, then no counter and no Semantics widget will
  /// be created at all.
  final InputCounterWidgetBuilder? buildCounter;

  @override
  _ColorPickerFieldState createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField>
    with RestorationMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimatedListModel<Color> _colorListAnimated;

  RestorableColorPickerFieldController? _controller;
  ColorPickerFieldController get _effectiveController =>
      widget.controller ?? _controller!.value;

  bool get _isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;
  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get needsCounter =>
      widget.maxColors != null &&
      widget.decoration != null &&
      widget.decoration!.counterText == null;

  bool _isHovering = false;

  int get _currentLength => _effectiveController.value.colors.length;

  bool get _hasIntrinsicError =>
      widget.maxColors != null &&
      widget.maxColors! > 0 &&
      _effectiveController.value.colors.length > widget.maxColors!;

  bool get _hasError =>
      widget.decoration?.errorText != null || _hasIntrinsicError;

  InputDecoration _getEffectiveDecoration() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration =
        (widget.decoration ?? const InputDecoration())
            .applyDefaults(themeData.inputDecorationTheme)
            .copyWith(
              enabled: _isEnabled,
              hintMaxLines: widget.decoration?.hintMaxLines ?? 1,
            );

    // No need to build anything if counter or counterText were given directly.
    if (effectiveDecoration.counter != null ||
        effectiveDecoration.counterText != null) return effectiveDecoration;

    // If buildCounter was provided, use it to generate a counter widget.
    Widget? counter;
    final int currentLength = _currentLength;
    if (effectiveDecoration.counter == null &&
        effectiveDecoration.counterText == null &&
        widget.buildCounter != null) {
      final bool isFocused = _effectiveFocusNode.hasFocus;
      final Widget? builtCounter = widget.buildCounter!(
        context,
        currentLength: currentLength,
        maxLength: widget.maxColors,
        isFocused: isFocused,
      );
      // If buildCounter returns null, don't add a counter widget to the field.
      if (builtCounter != null) {
        counter = Semantics(
          container: true,
          liveRegion: isFocused,
          child: builtCounter,
        );
      }
      return effectiveDecoration.copyWith(counter: counter);
    }

    if (widget.maxColors == null)
      return effectiveDecoration; // No counter widget

    String counterText = '$currentLength';
    String semanticCounterText = '';

    // Handle a real maxLength (positive number)
    if (widget.maxColors! > 0) {
      // Show the maxLength in the counter
      counterText += '/${widget.maxColors}';
      final int remaining =
          (widget.maxColors! - currentLength).clamp(0, widget.maxColors!);
      semanticCounterText =
          localizations.remainingTextFieldCharacterCount(remaining);
    }

    if (_hasIntrinsicError) {
      return effectiveDecoration.copyWith(
        errorText: effectiveDecoration.errorText ?? '',
        counterStyle: effectiveDecoration.errorStyle ??
            themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
        counterText: counterText,
        semanticCounterText: semanticCounterText,
      );
    }

    return effectiveDecoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    }
    _effectiveFocusNode.canRequestFocus = _isEnabled;
    _effectiveController.addListener(_handleOnChange);
    _colorListAnimated = AnimatedListModel<Color>(
      listKey: _listKey,
      initialItems: _effectiveController.colors,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  _handleOnChange() {
    widget.onChanged?.call(_colorListAnimated.items);
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ??
        NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return _isEnabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void didUpdateWidget(ColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
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
    _effectiveController.removeListener(_handleOnChange);
    _controller?.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        _isHovering = hovering;
      });
    }
  }

  Widget _buildRemovedItem(
    BuildContext context,
    Color item,
    Animation<double> animation,
  ) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.subtitle1!.merge(widget.style);
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.elasticIn,
      ),
      child: ColorItem(
        size: style.fontSize,
        item: item,
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.subtitle1!.merge(widget.style);

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: ColorItem(
        size: style.fontSize,
        item: _colorListAnimated[index],
      ),
    );
  }

  get isEmpty => _colorListAnimated.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextStyle style = theme.textTheme.subtitle1!.merge(widget.style);
    final ColorPickerFieldController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final TextDirection textDirection = Directionality.of(context);

    Widget child = RepaintBoundary(
      child: UnmanagedRestorationScope(
        bucket: bucket,
        child: EditableColorPickerField(
          listKey: _listKey,
          colorList: _colorListAnimated,
          controller: controller,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          focusNode: focusNode,
          itemBuilder: _buildItem,
          colorListReversed: widget.colorListReversed,
          style: style,
          restorationId: 'editableColor',
        ),
      ),
    );

    if (widget.decoration != null) {
      child = AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[focusNode, controller]),
        builder: (BuildContext context, Widget? child) {
          return InputDecorator(
            decoration: _getEffectiveDecoration(),
            baseStyle: widget.style,
            isHovering: _isHovering,
            isFocused: focusNode.hasFocus,
            isEmpty: controller.value.colors.isEmpty,
            expands: false,
            child: child,
          );
        },
        child: child,
      );
    }

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_isEnabled) MaterialState.disabled,
        if (_isHovering) MaterialState.hovered,
        if (focusNode.hasFocus) MaterialState.focused,
        if (_hasError) MaterialState.error,
      },
    );

    final int? semanticsMaxValueLength;
    if (widget.maxColors != null && widget.maxColors! > 0) {
      semanticsMaxValueLength = widget.maxColors;
    } else {
      semanticsMaxValueLength = null;
    }

    return MouseRegion(
      cursor: effectiveMouseCursor,
      onEnter: (PointerEnterEvent event) => _handleHover(true),
      onExit: (PointerExitEvent event) => _handleHover(false),
      child: IgnorePointer(
        ignoring: !_isEnabled,
        child: AnimatedBuilder(
          animation: controller, // changes the _currentLength
          builder: (BuildContext context, Widget? child) {
            // return Semantics(
            //   maxValueLength: semanticsMaxValueLength,
            //   currentValueLength: _currentLength,
            //   onTap: widget.readOnly
            //       ? null
            //       : () {
            //           _handleFocus();
            //           _openAddEntryDialog(_effectiveController);
            //         },
            //   onDidGainAccessibilityFocus: () {
            //     if (theme.platform == TargetPlatform.macOS) {
            //       _handleFocus();
            //     }
            //   },
            //   child: child,
            // );
            return InkWell(
              onTap: widget.readOnly
                  ? null
                  : () {
                      _handleFocus();

                      _openAddEntryDialog(
                        context,
                        _effectiveController,
                        textDirection,
                      );
                    },
              child: child,
            );
          },
          child: child,
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
    BuildContext context,
    ColorPickerFieldController controller,
    TextDirection textDirection,
  ) async {
    final DialogRoute<ColorPickerDialogModel> dialog =
        DialogRoute<ColorPickerDialogModel>(
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