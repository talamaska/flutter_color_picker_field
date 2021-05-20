import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_color_picker/components/colored_checkbox.dart';
import 'package:flutter_color_picker/models/color_dialog_model.dart';
import 'package:flutter_color_picker/components/color_picker.dart';
import 'package:flutter_color_picker/models/color_state_model.dart';

@immutable
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.initialColor,
    required this.colorList,
  });

  final Color initialColor;

  final List<Color> colorList;

  @override
  ColorPickerDialogState createState() {
    return ColorPickerDialogState();
  }
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  List<ColorState> _colorListState = <ColorState>[];
  late Color _newColor;

  @override
  void initState() {
    super.initState();
    _colorListState = widget.colorList.map((Color _color) {
      return ColorState(color: _color, selected: true);
    }).toList();
    _newColor = widget.initialColor;
  }

  bool? _getColorState(Color color) {
    if (color == null) {
      return false;
    }

    if (_colorListState.isEmpty) {
      return false;
    }

    return _colorListState
        .firstWhereOrNull(
          (ColorState _cs) => _cs.color == color,
        )
        ?.selected;
  }

  void _saveColor(Color? color) {
    Navigator.of(context).pop(ColorPickerDialogModel(
      color: color,
      colorStates: _colorListState,
    ));
  }

  void _changeColor(Color color) {
    setState(() {
      _newColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color picker'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _saveColor(null);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ColorPicker(
              currentColor: widget.initialColor,
              onSave: _saveColor,
              onChange: _changeColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                runSpacing: 13.0,
                spacing: 13.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: _getColorCheckboxes(),
              ),
            ),
          ),
        ],
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
          value: _getColorState(color),
          onChanged: (bool value) {
            _onColorSeletionChanged(value, color);
          },
        );
      },
    ).toList();
  }
}
