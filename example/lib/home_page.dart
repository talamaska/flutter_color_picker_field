import 'dart:developer';

import 'package:color_picker_field/color_picker_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialHomePage extends StatefulWidget {
  const MaterialHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MaterialHomePageState createState() => _MaterialHomePageState();
}

class _MaterialHomePageState extends State<MaterialHomePage> {
  Color defaultColor = HSLColor.fromColor(Colors.blue)
      .withSaturation(1.0)
      .withLightness(0.5)
      .toColor();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
