import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/colored_checkbox.dart';
import '../models/color_dialog_model.dart';
import '../components/color_picker.dart';
import '../models/color_state_model.dart';

@immutable
class CupertinoColorPickerDialog extends StatefulWidget {
  const CupertinoColorPickerDialog({
    required this.initialColor,
    required this.colorList,
  });

  final Color initialColor;

  final List<Color> colorList;

  @override
  CupertinoColorPickerDialogState createState() {
    return CupertinoColorPickerDialogState();
  }
}

class CupertinoColorPickerDialogState
    extends State<CupertinoColorPickerDialog> {
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Color picker'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Save'),
          onPressed: () {
            _saveColor(null);
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 86.0),
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
