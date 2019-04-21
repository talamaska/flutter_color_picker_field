import 'package:flutter/material.dart';
import 'package:flutter_color_picker/components/color_picker_input.dart';

class ColorPickerFormField extends FormField<List<Color>> {

  ColorPickerFormField({
    FormFieldSetter<List<Color>> onSaved,
    FormFieldValidator<List<Color>> validator,
    List<Color> initialValue,
    bool autovalidate = false,
    this.onChanged,
    this.defaultColor
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autovalidate,
      builder: (FormFieldState<List<Color>> state) {
        void _onChanged(List<Color> _colors) {
          debugPrint('onChange input $_colors');
          state.didChange(_colors);
          onChanged(_colors);
        }

        return ColorPickerInput(
            defaultColor: defaultColor,
            colors: initialValue,
            state: state,
            onChanged: _onChanged
        );
      }
  );

  final Function onChanged;
  final Color defaultColor;


}
