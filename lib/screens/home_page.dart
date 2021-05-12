import 'package:flutter/material.dart';

import 'package:flutter_color_picker/components/color_picker_form_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color defaultColor = Colors.blue;
  List<Color> _colorList = <Color>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onChanged(List<Color> colors) {
    _formKey.currentState.validate();
  }

  void _onSaved(List<Color> colors) {
    debugPrint('onSaved $colors');

    setState(() {
      _colorList = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: Center(
          child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: ColorPickerFormField(
                initialValue: _colorList,
                defaultColor: defaultColor,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (List<Color> value) {
                  if (value.isEmpty) {
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
                  if (_formKey.currentState.validate()) {
                    print('form is valid');
                  }
                },
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'My wishes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}
