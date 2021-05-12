import 'package:flutter/material.dart';
import 'package:flutter_color_picker/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: const Color(0xff03a9f4),
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}
