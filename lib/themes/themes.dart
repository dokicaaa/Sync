import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        surface: Color.fromARGB(255, 29, 29, 29),
        primary: Color(0xFF3A3A3A),
        secondary: Color.fromARGB(255, 1, 208, 32),
        tertiary: Colors.white),
    fontFamily: 'Poppins');

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        surface: Colors.grey.shade200,
        primary: Colors.white,
        secondary: Color.fromARGB(255, 1, 208, 32),
        tertiary: Colors.black),
    fontFamily: 'Poppins');
