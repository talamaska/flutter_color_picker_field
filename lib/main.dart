import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter_color_picker/screens/home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishmate',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: const Color(0xff03a9f4),
        secondaryHeaderColor:  TinyColor(const Color(0xff000000)).lighten(30).color,
        primaryColorDark: TinyColor(Colors.red).darken(5).color
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}


