import 'package:flutter/material.dart';

import 'lightness_slider_thumb.dart';
import 'lightness_slider_track.dart';

/// A custom slider used adjust the opacity value of a RGB color.
///
/// The slider has a typical checkered background often used in imaging
/// editing program to show the degree of opacity an image has.
///
/// The RGB [Color] we are adjusting the opacity for, is passed in the
/// [color] property and drawn as opacity gradient over the checkered
/// background to visually indicate how opaque or transparent the current
/// opacity value is. The opacity value is shown as 0 ... 100 (%) on
/// the adjustment thumb, 0 being fully transparent and 100, fully opaque.
///
/// The slider has 255 steps so that it is possible to select any corresponding
/// 8-bit alpha channel value. If the opacity is applied to a color using
/// `withOpacity` and the alpha value displayed in the resulting color, this
/// be observed.
///
/// The opacity value is returned via the onChanged called back. There are
/// also callbacks for [onChangeStart] and [onChangeEnd].
///
///

const double lightnessTrackHeight = 10;
const double lightnessThumbRadius = 16;

class LightnessSlider extends StatelessWidget {
  /// Create the opacity slider.
  const LightnessSlider({
    Key? key,
    required this.lightness,
    required this.color,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.thumbRadius = lightnessThumbRadius,
    this.trackHeight = lightnessTrackHeight,
    this.focusNode,
  }) : super(key: key);

  /// Current lightness value.
  final double lightness;

  /// Current selected color.
  final Color color;

  /// Called when the opacity value is changed.
  final ValueChanged<double> onChanged;

  /// Called when the user starts selecting a new value for the opacity slider.
  ///
  /// This callback shouldn't be used to update the slider value (use
  /// [onChanged] for that), but rather to be notified when the user has started
  /// selecting a new value by starting a drag or with a tap.
  ///
  /// The value passed will be the last value that the slider had before the
  /// change began.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider value (use
  /// [onChanged] for that), but rather to know when the user has completed
  /// selecting a new value by ending a drag or a click.
  final ValueChanged<double>? onChangeEnd;

  /// The radius of the thumb on the opacity slider.
  ///
  /// Defaults to 16.
  final double thumbRadius;

  /// The height of the slider track.
  ///
  /// Defaults to 36
  final double trackHeight;

  /// An optional focus node to use as the focus node for this widget.
  ///
  /// If one is not supplied, then one will be automatically allocated, owned,
  /// and managed by this widget. The widget will be focusable even if a
  /// focusNode is not supplied. If supplied, the given focusNode will be
  /// hosted by this widget, but not owned. See FocusNode for more information
  /// on what being hosted and/or owned implies.
  ///
  /// Supplying a focus node is sometimes useful if an ancestor to this
  /// widget wants to control when this widget has the focus. The owner will
  /// be responsible for calling FocusNode.dispose on the focus node when it is
  /// done with it, but this widget will attach/detach and reparent the
  /// node when needed.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Theme(
        data: _lightnessSliderTheme(color, trackHeight, thumbRadius, context),
        child: Slider(
          value: lightness,
          divisions: 1000,
          onChanged: onChanged,
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
          focusNode: focusNode,
        ),
      ),
    );
  }
}

/// To style the opacity slider we use a theme that changes with
/// passed in color value that the slider is manipulating opacity for.
ThemeData _lightnessSliderTheme(
  Color color,
  double trackHeight,
  double thumbRadius,
  BuildContext context,
) {
  // The thumbColor used for outline and text on [color] must have good
  // contrast with [color] so we can se it around the thumb and for text
  // written on top of the thumb fill [color].

  final Color thumbTextColor =
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
          ? const Color(0xFF333333)
          : Colors.white;
  final Orientation orientation = MediaQuery.of(context).orientation;
  return ThemeData.light().copyWith(
    sliderTheme: SliderThemeData(
      trackHeight: trackHeight,
      thumbColor: thumbTextColor,
      // The track uses a custom slider track, with a grid image background.
      trackShape: LightnessSliderTrack(
        color: color,
        textDirection: Directionality.of(context),
        thumbRadius: thumbRadius,
      ),
      // The thumb uses a custom thumb that is hollow.
      thumbShape: LightnessSliderThumb(
        color: color,
        orientation: orientation,
        enabledThumbRadius: thumbRadius,
      ),
    ),
  );
}
