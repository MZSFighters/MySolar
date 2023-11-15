import 'package:flutter/material.dart';

enum MyThemeKeys {BLUE, GREEN, ORANGE, RED, PINK, PURPLE}

class MyThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.blue),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.blue
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue
    ),
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: Colors.green,
    appBarTheme: AppBarTheme(color: Colors.green),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green
      )
    ),
        drawerTheme: DrawerThemeData(
      backgroundColor: Colors.green
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green
    ),
  );

  static final ThemeData orangeTheme = ThemeData(
    primaryColor: Colors.deepOrange,
    appBarTheme: AppBarTheme(color: Colors.deepOrange),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.deepOrange
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepOrange
    ),
  );

    static final ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    appBarTheme: AppBarTheme(color: Colors.red),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.red
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.red
    ),
  );

    static final ThemeData pinkTheme = ThemeData(
    primaryColor: Colors.pink,
    appBarTheme: AppBarTheme(color: Colors.pink),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.pink
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink
    ),
  );

    static final ThemeData purpleTheme = ThemeData(
    primaryColor: Colors.purple,
    appBarTheme: AppBarTheme(color: Colors.purple),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple
      )
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.purple
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.purple
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.white
    ),
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