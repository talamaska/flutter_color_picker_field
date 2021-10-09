import 'dart:developer';

import 'package:color_picker_field/color_picker_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoHomePage extends StatefulWidget {
  const CupertinoHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CupertinoHomePageState createState() => _CupertinoHomePageState();
}

class _CupertinoHomePageState extends State<CupertinoHomePage> {
  Color defaultColor = Colors.blue;
  List<Color> _colorList = <Color>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final ColorPickerFieldController controller = ColorPickerFieldController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      log('controller value ${controller.value}');
    });
  }

  void _onChanged(List<Color> colors) {
    _formKey.currentState!.validate();
  }

  void _onSaved(List<Color>? colors) {
    debugPrint('onSaved $colors');

    setState(() {
      _colorList = colors!;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // datePicker() {
  //   showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CupertinoTextField(
                    placeholder: 'CupertinoTextField',
                    clearButtonMode: OverlayVisibilityMode.always,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CupertinoColorPickerField(
                  placeholder: 'CupertinoColorPickerField',
                  colors: _colorList,
                  defaultColor: defaultColor,
                  onChanged: _onChanged,
                  clearButtonMode: ClearButtonVisibilityMode.always,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CupertinoColorPickerField(
                  placeholder:
                      'CupertinoColorPickerField with saturation and lightness',
                  colors: _colorList,
                  defaultColor: defaultColor,
                  onChanged: _onChanged,
                  clearButtonMode: ClearButtonVisibilityMode.always,
                  enableLightness: true,
                  enableSaturation: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CupertinoColorPickerField(
                  placeholder: 'CupertinoColorPickerField',
                  colors: _colorList,
                  defaultColor: defaultColor,
                  onChanged: _onChanged,
                  clearButtonMode: ClearButtonVisibilityMode.always,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CupertinoColorPickerField(
                  placeholder: 'CupertinoColorPickerField reversed',
                  colors: _colorList,
                  defaultColor: defaultColor,
                  onChanged: _onChanged,
                  colorListReversed: true,
                  clearButtonMode: ClearButtonVisibilityMode.always,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CupertinoColorPickerField(
                    placeholder: 'CupertinoColorPickerField',
                    colors: _colorList,
                    defaultColor: defaultColor,
                    onChanged: _onChanged,
                    clearButtonMode: ClearButtonVisibilityMode.always,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoFormSection.insetGrouped(
                header: const Text('Section 1'),
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: 'Ordinary text field',
                    prefix: const Text('Enter Text'),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: CupertinoTextFormFieldRow(
                      placeholder: 'Ordinary text field rtl',
                      prefix: const Text('Enter Text rtl'),
                    ),
                  ),
                  CupertinoColorPickerFormFieldRow(
                    prefix: const Text('Enter Color'),
                    defaultColor: defaultColor,
                    clearButtonMode: ClearButtonVisibilityMode.always,
                    placeholder: 'Enter Color',
                    onChanged: _onChanged,
                    validator: (List<Color>? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one color';
                      }
                      return null;
                    },
                  ),
                  CupertinoColorPickerFormFieldRow(
                    prefix: const Text('Enter Color'),
                    defaultColor: defaultColor,
                    placeholder: 'Enter Color',
                    onChanged: _onChanged,
                    colorListReversed: true,
                    validator: (List<Color>? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one color';
                      }
                      return null;
                    },
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: CupertinoColorPickerFormFieldRow(
                      prefix: const Text('Enter Color rtl'),
                      defaultColor: defaultColor,
                      placeholder: 'Enter Color rtl',
                      onChanged: _onChanged,
                      validator: (List<Color>? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter at least one color';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('form is valid');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
