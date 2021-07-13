import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color_picker_field.dart';
import '../components/colored_checkbox.dart';
import '../models/color_dialog_model.dart';
import '../components/color_picker.dart';
import '../models/color_state_model.dart';
import 'color_dialog.dart';

// final CupertinoThemeData themeData = CupertinoTheme.of(context);

//     final TextStyle? resolvedStyle = widget.style?.copyWith(
//       color: CupertinoDynamicColor.maybeResolve(widget.style?.color, context),
//       backgroundColor: CupertinoDynamicColor.maybeResolve(
//           widget.style?.backgroundColor, context),
//     );

//     final TextStyle textStyle =
//         themeData.textTheme.textStyle.merge(resolvedStyle);
@immutable
class CupertinoColorPickerDialog extends StatefulWidget {
  const CupertinoColorPickerDialog({
    required this.initialColor,
    required this.colorList,
    this.cancelText,
    this.confirmText,
    this.backText,
    this.helpText,
    this.titleText,
    this.style,
    this.textDirection = TextDirection.ltr,
    this.decoration,
  });

  final Color initialColor;
  final String? helpText;
  final String? titleText;
  final String? cancelText;
  final String? backText;
  final String? confirmText;
  final TextStyle? style;
  final TextDirection textDirection;
  final BoxDecoration? decoration;

  final List<Color> colorList;

  @override
  CupertinoColorPickerDialogState createState() {
    return CupertinoColorPickerDialogState();
  }
}

class CupertinoColorPickerDialogState
    extends State<CupertinoColorPickerDialog> {
  List<ColorState> _colorListState = <ColorState>[];
  bool colorPickerVisible = true;

  @override
  void initState() {
    super.initState();
    _colorListState = widget.colorList.map((Color _color) {
      return ColorState(color: _color, selected: true);
    }).toList();
  }

  bool _getColorState(Color color) {
    if (_colorListState.isEmpty) {
      return false;
    }

    return _colorListState.firstWhere((ColorState _cs) {
      return _cs.color == color;
    }, orElse: () => ColorState(color: color, selected: false)).selected;
  }

  void _handleOk(Color? color) {
    Navigator.of(context).pop(ColorPickerDialogModel(
      color: color,
      colorStates: _colorListState,
    ));
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return colorPickerPortraitDialogSize;
      case Orientation.landscape:
        return colorPickerLandscapeDialogSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData theme = CupertinoTheme.of(context);

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final CupertinoTextThemeData textTheme = theme.textTheme;
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    final Color onPrimarySurface = theme.brightness == Brightness.light
        ? theme.primaryContrastingColor
        : theme.scaffoldBackgroundColor;
    final TextStyle titleStyle = orientation == Orientation.landscape
        ? textTheme.dateTimePickerTextStyle.copyWith(color: onPrimarySurface)
        : textTheme.navLargeTitleTextStyle.copyWith(color: onPrimarySurface);

    final TextStyle style =
        theme.textTheme.navTitleTextStyle.merge(widget.style);

    final Widget header = _CupertinoColorPickerHeader(
      helpText: widget.helpText,
      titleText: widget.titleText,
      titleStyle: titleStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      textDirection: widget.textDirection,
    );

    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        textDirection: Directionality.of(context),
        children: <Widget>[
          CupertinoButton(
            child: Text(widget.cancelText ?? localizations.cancelButtonLabel),
            onPressed: _handleCancel,
          ),
          CupertinoButton(
            child: Text(widget.confirmText ?? localizations.saveButtonLabel),
            onPressed: () {
              _handleOk(null);
            },
          ),
        ],
      ),
    );

    final Widget secondaryActions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OverflowBar(
        spacing: 8,
        textDirection: widget.textDirection,
        children: <Widget>[
          SizedBox(
            width: 20,
            height: 20,
            child: InkWell(
              child: ColorGradientWidget(),
              onTap: () {
                setState(() {
                  colorPickerVisible = true;
                });
              },
            ),
          ),
        ],
      ),
    );

    final Widget picker = ColorPicker(
      currentColor: widget.initialColor,
      onSave: _handleOk,
    );

    final Widget checkboxes = Wrap(
      runSpacing: 13.0,
      spacing: 13.0,
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: _getColorCheckboxes(),
    );

    final Widget checkboxesGrid = GridView.count(
      crossAxisCount: 4,
      shrinkWrap: false,
      children: [
        for (var i = 0; i < widget.colorList.length; i++)
          ColoredGridCheckbox(
            color: widget.colorList[i],
            value: _getColorState(widget.colorList[i]),
            onChanged: (bool value) {
              _onColorSeletionChanged(value, widget.colorList[i]);
            },
          )
      ],
    );

    final Widget switcher = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            colorPickerVisible = false;
          });
        },
        child: Container(
          decoration: widget.decoration,
          padding: EdgeInsets.all(6.0),
          child: Directionality(
            textDirection: widget.textDirection,
            child: SizedBox(
              width: double.infinity,
              height: style.fontSize,
              child: ListView.builder(
                padding: const EdgeInsets.all(1.0),
                scrollDirection: Axis.horizontal,
                itemCount: widget.colorList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ColorItem(
                    size: style.fontSize,
                    item: widget.colorList[index],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    return Directionality(
      textDirection: widget.textDirection,
      child: Dialog(
        child: AnimatedContainer(
          width: dialogSize.width,
          height: dialogSize.height,
          duration: dialogSizeAnimationDuration,
          curve: Curves.easeIn,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: textScaleFactor,
            ),
            child: Builder(builder: (BuildContext context) {
              if (colorPickerVisible) {
                switch (orientation) {
                  case Orientation.portrait:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        header,
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: picker,
                        ),
                        if (widget.colorList.isNotEmpty) switcher,
                      ],
                    );
                  case Orientation.landscape:
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        header,
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: picker,
                              ),
                            ],
                          ),
                        ),
                        if (widget.colorList.isNotEmpty) switcher,
                      ],
                    );
                }
              } else {
                switch (orientation) {
                  case Orientation.portrait:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        header,
                        secondaryActions,
                        Flexible(
                          child: checkboxesGrid,
                        ),
                        actions,
                      ],
                    );
                  case Orientation.landscape:
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        header,
                        secondaryActions,
                        Flexible(
                          child: checkboxesGrid,
                        ),
                        actions,
                      ],
                    );
                }
              }
            }),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  void _onColorSeletionChanged(bool value, Color color) {
    setState(() {
      _colorListState = _colorListState.map((ColorState cs) {
        if (cs.color == color) {
          return ColorState(
            color: color,
            selected: value,
          );
        } else {
          return cs;
        }
      }).toList();
    });
  }

  List<ColoredCheckbox> _getColorCheckboxes() {
    return widget.colorList.map(
      (Color color) {
        return ColoredCheckbox(
          color: color,
          size: Size(24.0, 24.0),
          value: _getColorState(color),
          onChanged: (bool value) {
            _onColorSeletionChanged(value, color);
          },
        );
      },
    ).toList();
  }
}

class _CupertinoColorPickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const _CupertinoColorPickerHeader({
    Key? key,
    this.helpText,
    this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key);

  static const double _colorPickerHeaderLandscapeWidth = 152.0;
  static const double _colorPickerHeaderPortraitHeight = 120.0;
  static const double _headerPaddingLandscape = 16.0;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// The text that is displayed at the center of the header.
  final String? titleText;

  /// The semantic label associated with the [titleText].
  final String? titleSemanticsLabel;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle titleStyle;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  final TextDirection textDirection;

  /// Indicates the header is being displayed in a shorter/narrower context.
  ///
  /// This will be used to tighten up the space between the help text and date
  /// text if `true`. Additionally, it will use a smaller typography style if
  /// `true`.
  ///
  /// This is necessary for displaying the manual input mode in
  /// landscape orientation, in order to account for the keyboard height.
  final bool isShort;

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData theme = CupertinoTheme.of(context);
    // final ColorScheme colorScheme = theme.colorScheme;
    final CupertinoTextThemeData textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = theme.brightness == Brightness.dark;
    final Color primarySurfaceColor =
        isDark ? theme.scaffoldBackgroundColor : theme.primaryColor;
    final Color onPrimarySurfaceColor =
        isDark ? theme.primaryColor : theme.primaryContrastingColor;

    final TextStyle? helpStyle = textTheme.textStyle.copyWith(
      color: onPrimarySurfaceColor,
    );
    final TextStyle _titleStyle = titleStyle.copyWith(
      color: onPrimarySurfaceColor,
    );

    final Widget help = Text(
      helpText ?? 'test',
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: Directionality.of(context),
    );
    final Text title = Text(
      titleText ?? 'Color Picker',
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: _titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      textDirection: Directionality.of(context),
    );

    switch (orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: _colorPickerHeaderPortraitHeight,
          child: Material(
            color: primarySurfaceColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: textDirection,
                children: <Widget>[
                  const SizedBox(height: 16),
                  help,
                  const Flexible(child: SizedBox(height: 38)),
                  title
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: _colorPickerHeaderLandscapeWidth,
          child: Material(
            color: primarySurfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
                SizedBox(height: isShort ? 16 : 56),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _headerPaddingLandscape,
                    ),
                    child: title,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
