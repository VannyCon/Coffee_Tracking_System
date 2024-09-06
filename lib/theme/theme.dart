import 'package:flutter/material.dart';

class MyColorSchemes {
  static const lightModeScheme = ColorScheme.light(
    primary: Color(0xFFEF233C), //primary
    secondary: Color(0xFFFFFAFA), //secondary
    background: Color(0xFFF2E9E9), //background
    surface: Color(0xFFFFFAFA), //box
    onBackground: Color(0xFF2A2A2A), //text
    error: Color.fromARGB(255, 231, 81, 81),
    onError: Colors.white,
    onPrimary: Color.fromARGB(255, 40, 202, 56),
    onSecondary: Color.fromARGB(255, 71, 143, 250),
    onSurface: Color(0xFFFFFAFA),
    brightness: Brightness.light,
    outline: Color.fromARGB(255, 88, 88, 89),
    tertiary: Color(0xFF6939CF),
  );

  static const darkModeScheme = ColorScheme.dark(
    primary: Color(0xFFEF233C),
    secondary: Color(0xFF272B30),
    background: Color(0xFF1A1D1F),
    surface: Color(0xFF272B30),
    onBackground: Color(0xFFF3EBEB),
    error: Color.fromARGB(255, 231, 81, 81),
    onError: Colors.white,
    onPrimary: Color.fromARGB(255, 40, 202, 56),
    onSecondary: Color.fromARGB(255, 71, 143, 250),
    onSurface: Color(0xFF272B30),
    brightness: Brightness.dark,
    outline: Color(0xFFB6BECB),
    tertiary: Color(0xFF6939CF),
  );
}
