import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/color_gradient_widget.dart';
import '../components/color_item.dart';
import '../components/color_picker_form_field.dart';
import '../components/colored_checkbox.dart';
import '../components/hsl_color_picker.dart';
import '../components/lightness_slider/lightness_slider.dart';
import '../components/saturation_slider/saturation_slider.dart';
import '../models/color_dialog_model.dart';
import '../models/color_state_model.dart';

const Duration dialogSizeAnimationDuration = Duration(milliseconds: 200);

@immutable
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    Key? key,
    required this.initialColor,
    required this.colorList,
    this.cancelText,
    this.confirmText,
    this.backText,
    this.helpText,
    this.titleText,
    this.titleSemanticsLabel,
    this.style,
    this.textDirection = TextDirection.ltr,
    this.enableSaturation = false,
    this.enableLightness = false,
    this.selectedColorItemBuilder,
  }) : super(key: key);

  final Color initialColor;
  final String? helpText;
  final String? titleText;
  final String? titleSemanticsLabel;
  final String? cancelText;
  final String? backText;
  final String? confirmText;
  final TextStyle? style;
  final TextDirection textDirection;
  final SelectedColorItemBuilder? selectedColorItemBuilder;

  final List<Color> colorList;

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
  ColorPickerDialogState createState() {
    return ColorPickerDialogState();
  }
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  List<ColorState> _colorListState = <ColorState>[];
  late Color currentColor;
  late double hue;
  late double saturation;
  late double lightness;
  late HSLColor hslColor;
  bool colorPickerVisible = true;
  late FocusNode _saturationFocusNode;
  late FocusNode _lightnessFocusNode;

  @override
  void initState() {
    super.initState();
    _saturationFocusNode = FocusNode();
    _lightnessFocusNode = FocusNode();

    _colorListState = widget.colorList.map((Color color) {
      return ColorState(color: color, selected: true);
    }).toList();

    currentColor = widget.initialColor;
    hslColor = HSLColor.fromColor(widget.initialColor);
    hue = hslColor.hue;
    saturation = hslColor.saturation;
    lightness = hslColor.lightness;
  }

  bool _getColorState(Color color) {
    if (_colorListState.isEmpty) {
      return false;
    }

    return _colorListState.firstWhere((ColorState cs) {
      return cs.color == color;
    }, orElse: () => ColorState(color: color, selected: false)).selected;
  }

  void _handleOnChange(Color color) {
    setState(() {
      currentColor = color;
    });
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
    final Size size = MediaQuery.of(context).size;
    switch (orientation) {
      case Orientation.portrait:
        return size;
      case Orientation.landscape:
        return size;
    }
  }

  static Widget _defaultSelectedColorItemBuilder(
      Color color, bool selected, SelectionChangeCallback onSelectionChange) {
    return ColoredGridCheckbox(
      color: color,
      value: selected,
      onChanged: (bool value) {
        onSelectionChange(selected, color);
      },
    );
  }

  @override
  void dispose() {
    _saturationFocusNode.dispose();
    _lightnessFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final TextTheme textTheme = theme.textTheme;
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    final Color onPrimarySurface = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle? titleStyle = orientation == Orientation.landscape
        ? textTheme.headlineSmall?.copyWith(color: onPrimarySurface)
        : textTheme.headlineMedium?.copyWith(color: onPrimarySurface);

    final TextStyle style = theme.textTheme.titleMedium!.merge(widget.style);

    final Widget header = _ColorPickerHeader(
      titleText: widget.titleText,
      titleSemanticsLabel: widget.titleSemanticsLabel,
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
          TextButton(
            onPressed: _handleCancel,
            child: Text(widget.cancelText ?? localizations.cancelButtonLabel),
          ),
          TextButton(
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
              child: const ColorGradientWidget(),
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

    final Widget picker = HSLColorPicker(
      currentColor: currentColor,
      hue: hue,
      saturation: saturation,
      lightness: lightness,
      onSave: _handleOk,
      onChange: _handleOnChange,
    );

    // deprecated
    // final Widget checkboxes = Wrap(
    //   runSpacing: 13.0,
    //   spacing: 13.0,
    //   direction: Axis.horizontal,
    //   alignment: WrapAlignment.start,
    //   crossAxisAlignment: WrapCrossAlignment.start,
    //   children: _getColorCheckboxes(),
    // );

    final Widget checkboxesGrid = GridView.count(
      crossAxisCount: 4,
      shrinkWrap: false,
      children: widget.colorList.map((Color entry) {
        if (widget.selectedColorItemBuilder != null) {
          return widget.selectedColorItemBuilder!(entry, _getColorState(entry),
              (bool selected, Color color) {
            _onColorSelectionChanged(selected, color);
          });
        } else {
          return _defaultSelectedColorItemBuilder(entry, _getColorState(entry),
              (bool selected, Color color) {
            _onColorSelectionChanged(selected, color);
          });
        }
      }).toList(),
    );

    final Widget checkboxesGridLandscape = GridView.count(
      crossAxisCount: 8,
      shrinkWrap: false,
      children: widget.colorList.map((Color entry) {
        if (widget.selectedColorItemBuilder != null) {
          return widget.selectedColorItemBuilder!(
            entry,
            _getColorState(entry),
            (bool selected, Color color) {
              _onColorSelectionChanged(selected, color);
            },
          );
        } else {
          return _defaultSelectedColorItemBuilder(
            entry,
            _getColorState(entry),
            (bool selected, Color color) {
              _onColorSelectionChanged(selected, color);
            },
          );
        }
      }).toList(),
    );

    final Widget saturationSlider = Padding(
      padding: orientation == Orientation.portrait
          ? const EdgeInsets.symmetric(horizontal: 16.0)
          : const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: orientation == Orientation.portrait ? double.infinity : null,
        height: orientation == Orientation.landscape ? double.infinity : null,
        child: RepaintBoundary(
          child: RotatedBox(
            quarterTurns: orientation == Orientation.landscape ? -1 : 0,
            child: SaturationSlider(
              color: currentColor,
              saturation: saturation,
              focusNode: _saturationFocusNode,
              onChangeStart: (double value) {
                setState(() {
                  saturation = value;
                });
              },
              onChanged: (double value) {
                setState(() {
                  saturation = value;
                });
              },
              onChangeEnd: (double value) {
                setState(() {
                  saturation = value;
                });
              },
            ),
          ),
        ),
      ),
    );

    final Widget lightnessSlider = Padding(
      padding: orientation == Orientation.portrait
          ? const EdgeInsets.symmetric(horizontal: 16.0)
          : const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: orientation == Orientation.portrait ? double.infinity : null,
        height: orientation == Orientation.landscape ? double.infinity : null,
        child: RepaintBoundary(
          child: RotatedBox(
            quarterTurns: orientation == Orientation.landscape ? -1 : 0,
            child: LightnessSlider(
              color: currentColor,
              lightness: lightness,
              focusNode: _lightnessFocusNode,
              onChangeStart: (double value) {
                setState(() {
                  lightness = value;
                });
              },
              onChanged: (double value) {
                setState(() {
                  lightness = value;
                });
              },
              onChangeEnd: (double value) {
                setState(() {
                  lightness = value;
                });
              },
            ),
          ),
        ),
      ),
    );

    final Widget switcher = Padding(
      padding: orientation == Orientation.portrait
          ? const EdgeInsets.symmetric(horizontal: 16.0)
          : const EdgeInsets.only(
              left: 8.0,
              top: 16.0,
              bottom: 16.0,
              right: 24,
            ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          visualDensity: VisualDensity.compact,
        ),
        onPressed: () {
          setState(() {
            colorPickerVisible = false;
          });
        },
        child: Directionality(
          textDirection: widget.textDirection,
          child: Builder(builder: (BuildContext context) {
            switch (orientation) {
              case Orientation.portrait:
                return SizedBox(
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
                );
              case Orientation.landscape:
                return SizedBox(
                  width: style.fontSize,
                  height: double.infinity,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(1.0),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.colorList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ColorItem(
                        size: style.fontSize,
                        item: widget.colorList[index],
                      );
                    },
                  ),
                );
            }
          }),
        ),
      ),
    );

    return Directionality(
      textDirection: widget.textDirection,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        clipBehavior: Clip.antiAlias,
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
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          header,
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: picker,
                          ),
                          if (widget.enableSaturation) saturationSlider,
                          if (widget.enableLightness) lightnessSlider,
                          if (widget.colorList.isNotEmpty) switcher,
                        ],
                      ),
                    );
                  case Orientation.landscape:
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          header,
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: picker,
                            ),
                          ),
                          if (widget.enableSaturation) saturationSlider,
                          if (widget.enableLightness) lightnessSlider,
                          if (widget.colorList.isNotEmpty) switcher,
                        ],
                      ),
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
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              secondaryActions,
                              Flexible(
                                child: checkboxesGridLandscape,
                              ),
                              actions,
                            ],
                          ),
                        )
                      ],
                    );
                }
              }
            }),
          ),
        ),
      ),
    );
  }

  void _onColorSelectionChanged(bool value, Color color) {
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

  // List<ColoredCheckbox> _getColorCheckboxes() {
  //   return widget.colorList.map(
  //     (Color color) {
  //       return ColoredCheckbox(
  //         color: color,
  //         size: const Size(24.0, 24.0),
  //         value: _getColorState(color),
  //         onChanged: (bool value) {
  //           _onColorSelectionChanged(value, color);
  //         },
  //       );
  //     },
  //   ).toList();
  // }
}

class _ColorPickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const _ColorPickerHeader({
    Key? key,
    this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key);

  static const double _headerPaddingLandscape = 16.0;

  /// The text that is displayed at the center of the header.
  final String? titleText;

  /// The semantic label associated with the [titleText].
  final String? titleSemanticsLabel;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle? titleStyle;

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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color primarySurfaceColor =
        isDark ? colorScheme.surface : colorScheme.primary;

    final Text title = Text(
      titleText ?? 'Color Picker',
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: titleStyle ?? theme.dialogTheme.titleTextStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      textDirection: Directionality.of(context),
    );

    switch (orientation) {
      case Orientation.portrait:
        return Material(
          color: primarySurfaceColor,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 24,
              end: 24,
              bottom: 16,
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: textDirection,
              children: <Widget>[title],
            ),
          ),
        );
      case Orientation.landscape:
        return Material(
          color: primarySurfaceColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: title,
                ),
              ),
            ],
          ),
        );
    }
  }
}
