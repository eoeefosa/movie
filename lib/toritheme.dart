import 'package:flutter/material.dart';

class ToriTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 14.0,
        color: Colors.grey.shade900,
        fontWeight: FontWeight.w700),
    displayLarge: TextStyle(
        fontFamily: 'openSans',
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900),
    displayMedium: TextStyle(
      fontFamily: 'openSans',
      fontSize: 21.0,
      color: Colors.grey.shade900,
    ),
    displaySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade900,
    ),
    titleLarge: TextStyle(
      fontFamily: 'openSans',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade900,
    ),
    bodySmall: TextStyle(
      fontFamily: 'openSans',
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade900,
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
        fillColor:
            WidgetStateColor.resolveWith((states) => Colors.grey.shade900),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.grey.shade900,
        backgroundColor: Colors.white,
      ),
      cardColor: Colors.blue,
      // cardTheme:
      //     CardTheme(color: Colors.green, surfaceTintColor: Colors.green),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade900,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              textStyle: const TextStyle(color: Colors.white))),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedLabelStyle: TextStyle(color: Colors.grey.shade900),
          showUnselectedLabels: true,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey.shade900),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => Colors.white),
      ),
      // textButtonTheme: TextButtonThemeData(
      //     style:
      //         ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero))),
      cardColor: Colors.blueGrey[900],
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        backgroundColor: Colors.greenAccent.shade700,
        textStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.grey.shade200,
      )),
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
        unselectedItemColor: Colors.white,
      ),
      textTheme: darkTextTheme,
    );
  }
}
