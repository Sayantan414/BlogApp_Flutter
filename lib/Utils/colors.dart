import 'package:flutter/material.dart';

const lightColors = {
  "primary": Color(0xFFFEFFDE),
  "secondary": Color.fromARGB(255, 221, 255, 188),
  "tertiary": Color(0xFF91C788),
  "text": Color(0xFF52734D),
  "button": Color(0xFF52734D),
  "buttonText": Color.fromARGB(255, 247, 249, 247),
  "daysago": Color.fromARGB(255, 96, 95, 95),
  "fillColor": Color.fromARGB(255, 223, 240, 206)
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
