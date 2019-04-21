
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_color_picker/models/animated_color_list_model.dart';
import 'package:flutter_color_picker/screens/color_dialog.dart';
import 'package:flutter_color_picker/models/color_dialog_model.dart';

import 'package:flutter_color_picker/components/color_item.dart';
import 'package:flutter_color_picker/models/color_state_model.dart';


class ColorPickerInput extends StatefulWidget {
  const ColorPickerInput({
    this.defaultColor,
    this.colors,
    this.onChanged,
    this.state
  });

  final Color defaultColor;
  final List<Color> colors;
  final Function onChanged;
  final FormFieldState<List<Color>> state;

  @override
  _ColorPickerInputState createState() => _ColorPickerInputState();
}

class _ColorPickerInputState extends State<ColorPickerInput> {
  Color _defaultColor;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedColorListModel<Color> _colorListA;


  @override
  void initState() {
    super.initState();
    _defaultColor = widget.defaultColor != null ? widget.defaultColor : Colors.blue;
    if(widget.colors != null) {
      _colorListA = AnimatedColorListModel<Color>(
        listKey: _listKey,
        initialItems: widget.colors,
        removedItemBuilder: _buildRemovedItem,
      );


    }
  }

  Widget _buildRemovedItem(Color item, BuildContext context, Animation<double> animation) {
    return ScaleTransition(
      scale: CurvedAnimation(
          parent: animation,
          curve: Curves.elasticIn
      ),
      child: ColorItem(
        item: item,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return ScaleTransition(
      scale: CurvedAnimation(
          parent: animation,
          curve: Curves.bounceOut
      ),
      child: ColorItem(
        item: _colorListA[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openAddEntryDialog,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 56.0,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0, color: widget.state.hasError ? Theme.of(context).errorColor : Theme.of(context).dividerColor))
            ),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: _colorListA.isNotEmpty ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: _colorListA.isNotEmpty ? const EdgeInsets.only(bottom: 3.0) : const EdgeInsets.only(bottom: 0.0),
                  height: _colorListA.isNotEmpty ? 14.0 : 16.0,
                  child: Text('Colors', style: Theme.of(context).textTheme.subhead.copyWith(
                    color: const Color(0x8a000000),
                    fontSize: _colorListA.isNotEmpty ? 14.0 : 16.0,
                  )),
                ),
                Container(
                  height: _colorListA.isNotEmpty ? 28.0 : 0.0,

                  child: AnimatedList(
                    padding: const EdgeInsets.all(2.0),
                    key: _listKey,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: _colorListA.length,
                    itemBuilder: _buildItem,
                  ),
                )

              ],
            ),
          ),
          widget.state.hasError ? Text(
            widget.state.errorText,
            style: TextStyle(

              color: Theme.of(context).errorColor
            ),
          ) :
          Container()
        ],
      ),
    );
  }

  Future<void> _openAddEntryDialog() async {
    final MaterialPageRoute<ColorPickerDialogModel> dialog = MaterialPageRoute<ColorPickerDialogModel>(
      builder: (BuildContext context) {
        return ColorPickerDialog.add(_defaultColor, _colorListA.items);
      },
      fullscreenDialog: true,
    );

    final ColorPickerDialogModel save = await Navigator.of(context).push(dialog);

    dialog.completed.then((ColorPickerDialogModel value) {
      print(value.toString());
      if(value != null) {
        if(save.colorStates.isNotEmpty) {
          _updateColors(value.color, value.colorStates);
        }

        if (value.color != null) {
          _saveColor(value.color);
        }
      }
    });

  }

  void _saveColor(Color _color) {
    print(_color);
    setState(() {
      if(!_colorListA.contains(_color)) {
        _colorListA.insert(_colorListA.length, _color);
        widget.onChanged(_colorListA.items);
      }
    });
  }

  void _updateColors(Color _color, List<ColorState> _colors) {
    print(_colors);
    setState(() {
      // ignore: always_specify_types
      for(var i = 0; i < _colors.length; i++) {
        if(!_colors[i].state) {
          var index = _colorListA.indexOf(_colors[i].color);
          if(index != -1) {
            _colorListA.removeAt(index);
          }

        }
      }

      if (_color == null) {
        widget.onChanged(_colorListA.items);
      }

    });
  }
}



