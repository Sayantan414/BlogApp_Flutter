import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: _buildTheme(Brightness.dark),
        home: WelcomePage());
  }
  // ThemeData _buildTheme(brightness) {
  //   var baseTheme = ThemeData(brightness: brightness);

  //   return baseTheme.copyWith(
  //     textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
  //   );
  // }
}
