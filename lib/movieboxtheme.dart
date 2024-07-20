import 'package:flutter/material.dart';

class MovieBoxTheme {
  static TextTheme lightTextTheme = const TextTheme(
    bodyLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 14.0,
        color: Colors.black,
        fontWeight: FontWeight.w700),
    displayLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black),
    displayMedium: TextStyle(
      fontFamily: 'openSans',
      fontSize: 21.0,
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: 'openSans',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
  static TextTheme darkTextTheme = const TextTheme(
    bodyLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 14.0,
        color: Colors.white,
        fontWeight: FontWeight.w700),
    displayLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white),
    displayMedium: TextStyle(
      fontFamily: 'openSans',
      fontSize: 21.0,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontFamily: 'openSans',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => Colors.black),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      cardColor: Colors.blue,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedLabelStyle: TextStyle(color: Colors.black),
          showUnselectedLabels: true,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => Colors.white),
      ),
      // textButtonTheme: const TextButtonThemeData(
      //     style:
      //         ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero))),
      cardColor: Colors.blueGrey[900],
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      tabBarTheme: const TabBarTheme(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white),
      textTheme: darkTextTheme,
    );
  }
}
