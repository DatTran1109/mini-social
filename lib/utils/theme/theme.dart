import 'package:flutter/material.dart';

ThemeData lighTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade100,
    secondary: Colors.grey.shade300,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade800,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
);
