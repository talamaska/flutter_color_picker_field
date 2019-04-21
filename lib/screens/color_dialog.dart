import 'package:flutter/material.dart';
import 'package:flutter_color_picker/components/colored_checkbox.dart';
import 'package:flutter_color_picker/models/color_dialog_model.dart';
import 'package:flutter_color_picker/components/color_picker.dart';
import 'package:flutter_color_picker/models/color_state_model.dart';

@immutable
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog.add(
      this.initialColor,
      this.colorList
      ) : colorToEdit = null;

  const ColorPickerDialog.edit(
      this.colorToEdit,
      this.colorList
      ) : initialColor = colorToEdit;

  final Color initialColor;
  final Color colorToEdit;
  final List<Color> colorList;

  @override
  ColorPickerDialogState createState() {
    return ColorPickerDialogState();
  }
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  List<ColorState> _colorListState = <ColorState>[];
  Color _newColor;

  @override
  void initState() {
    super.initState();
    _colorListState = widget.colorList.map((Color _color) {
      return ColorState(color: _color, state: true);
    }).toList();
    _newColor = widget.initialColor;
  }

  bool _getColorState(Color _color) {
    return _colorListState.firstWhere((ColorState _cs) {
      return _cs.color == _color;
    }).state;
  }

  void _saveColor(Color _color) {
    Navigator
      .of(context)
      .pop(ColorPickerDialogModel(
        color: _color,
        colorStates: _colorListState
      ));
  }

  void _changeColor(Color _color) {
    setState(() {
      _newColor = _color;
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
              saveColor: _saveColor,
              changeColor: _changeColor
            )

          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child:  Wrap(
              runSpacing: 13.0,
              spacing: 13.0,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: widget.colorList.map((Color _color) => GestureDetector(
                onTap: () {
                  setState(() {
                    _colorListState = _colorListState.map((ColorState _cs) {
                      if(_cs.color == _color) {
                        return ColorState(color: _color, state: !_cs.state);
                      } else {
                        return _cs;
                      }
                    }).toList();
                  });
                },
                child: ColoredCheckbox(color: _color, state: _getColorState(_color)),
              )).toList(),
            ),
          ),
        ],
      )
    );
  }
}


