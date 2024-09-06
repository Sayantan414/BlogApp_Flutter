import 'package:flutter/material.dart';

const lightColors = {
  "primary": Color(0xFFE4F9F5),
  "secondary": Color.fromARGB(255, 199, 245, 236),
  "tertiary": Color(0xFF11999E),
  "text": Color(0xFF40514E),
  "button": Color(0xFF11999E),
  "buttonText": Color.fromARGB(255, 247, 249, 247),
  "daysago": Color.fromARGB(255, 96, 95, 95),
  "fillColor": Color.fromARGB(255, 188, 231, 240),
  "inactiveState": Color.fromARGB(255, 172, 201, 196),
  "loader": Color(0xFF11999E),
  "like": Colors.blue,
  "view": Colors.grey,
};

const darkColors = {
  "primary": Color(0xFF1E201E),
  "secondary": Color(0xFF3C3D37),
  "tertiary": Color(0xFF697565),
  "text": Color(0xFFECDFCC),
  "button": Color.fromARGB(255, 246, 238, 226),
  "buttonText": Color(0xFF1E201E),
  "daysago": Color.fromARGB(134, 236, 223, 204),
  "fillColor": Color.fromARGB(255, 97, 98, 93),
  "inactiveState": Color(0xFF3C3D37),
  "loader": Color(0xFFECDFCC),
  "like": Color.fromARGB(255, 2, 119, 214),
  "view": Color.fromARGB(255, 220, 219, 219),
};

colorTheme(context) {
  ThemeMode currentThemeMode = Theme.of(context).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;
  if (currentThemeMode == ThemeMode.dark) {
    return darkColors;
  } else if (currentThemeMode == ThemeMode.light) {
    return lightColors;
  }
}
