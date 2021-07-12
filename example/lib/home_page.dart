import 'dart:developer';

import 'package:color_picker_field/color_picker_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: Colors.deepPurple.shade700,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CupertinoTextField(
                    placeholder: 'CupertinoTextField',
                    clearButtonMode: OverlayVisibilityMode.always,
                  ),
                ),
              ),
              SizedBox(
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
              SizedBox(
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
              SizedBox(
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
              SizedBox(
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'TextField rtl',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'TextFormField',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ColorPickerFormField(
                  initialValue: _colorList,
                  defaultColor: defaultColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxColors: 3,
                  decoration: InputDecoration(
                    labelText: 'Colors',
                    helperText: 'test',
                  ),
                  validator: (List<Color>? value) {
                    if (value!.isEmpty) {
                      return 'a minimum of 1 color is required';
                    }
                    return null;
                  },
                  onChanged: _onChanged,
                  onSaved: _onSaved,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ColorPickerField(
                    colors: _colorList,
                    defaultColor: defaultColor,
                    onChanged: _onChanged,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Colors rtl',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ColorPickerFormField(
                  initialValue: _colorList,
                  defaultColor: defaultColor,
                  colorListReversed: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxColors: 3,
                  decoration: InputDecoration(
                    labelText: 'Colors reversed',
                    helperText: 'test',
                  ),
                  validator: (List<Color>? value) {
                    if (value!.isEmpty) {
                      return 'a minimum of 1 color is required';
                    }
                    return null;
                  },
                  onChanged: _onChanged,
                  onSaved: _onSaved,
                ),
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
