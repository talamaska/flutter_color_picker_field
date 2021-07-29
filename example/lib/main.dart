import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cupertino_home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';

// void main() => runApp(MyMaterialApp());
void main() => runApp(MyCupertinoApp());

class MyCupertinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Color Picker',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange,
        brightness: Brightness.light,
      ),
      home: const CupertinoHomePage(title: 'Color Picker Cupertino'),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale('en_US'),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
      ),
      home: const MaterialHomePage(title: 'Color Picker Material'),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: Locale('en_US'),
    );
  }
}
