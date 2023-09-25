import 'package:flutter/material.dart';

enum MyThemeKeys {BLUE, GREEN, ORANGE, RED, PINK, PURPLE}

class MyThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.blue)
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: Colors.green,
    appBarTheme: AppBarTheme(color: Colors.green)
  );

  static final ThemeData orangeTheme = ThemeData(
    primaryColor: Colors.deepOrange,
    appBarTheme: AppBarTheme(color: Colors.deepOrange)
  );

    static final ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    appBarTheme: AppBarTheme(color: Colors.red)
  );

    static final ThemeData pinkTheme = ThemeData(
    primaryColor: Colors.pink,
    appBarTheme: AppBarTheme(color: Colors.pink)
  );

    static final ThemeData purpleTheme = ThemeData(
    primaryColor: Colors.purple,
    appBarTheme: AppBarTheme(color: Colors.purple)
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.BLUE:
        return blueTheme;
      case MyThemeKeys.GREEN:
        return greenTheme;
      case MyThemeKeys.ORANGE:
        return orangeTheme;
      case MyThemeKeys.RED:
        return redTheme;
      case MyThemeKeys.PINK:
        return pinkTheme;
      case MyThemeKeys.PURPLE:
        return purpleTheme;
    }
  }
}