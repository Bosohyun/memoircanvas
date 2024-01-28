import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final Color _iconColor = Colors.blueAccent.shade200;
  static const Color _lightPrimaryColor = Color.fromARGB(255, 74, 109, 167);
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;
  static const Color _lightBackgroundColor = Colors.white;
  static const Color _lightTertiaryColor = Colors.white;

  static const Color _darkPrimaryColor = Colors.white54;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;
  static const Color _darkBackgroundColor = Colors.black;
  static const Color _darkTertiaryColor = Colors.grey;

  static final ThemeData lightTheme = ThemeData(
      // appBarTheme: const AppBarTheme(
      //   titleTextStyle: TextStyle(
      //       color: _darkSecondaryColor,
      //       fontFamily: "Roboto",
      //       fontWeight: FontWeight.bold,
      //       fontSize: 26),
      //   color: _lightPrimaryVariantColor,
      //   iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      // ),
      colorScheme: const ColorScheme.light(
          background: _lightBackgroundColor,
          primary: _lightPrimaryColor,
          secondary: _lightSecondaryColor,
          onPrimary: _lightOnPrimaryColor,
          tertiary: _lightTertiaryColor),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _lightTextTheme,
      dividerTheme: const DividerThemeData(color: Colors.black12));

  static final ThemeData darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        color: _darkPrimaryVariantColor,
        iconTheme: IconThemeData(color: _darkOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.dark(
          background: _darkBackgroundColor,
          primary: _darkPrimaryColor,
          secondary: _darkSecondaryColor,
          onPrimary: _darkOnPrimaryColor,
          tertiary: _darkTertiaryColor),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _darkTextTheme,
      dividerTheme: const DividerThemeData(color: Colors.black));

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: _lightScreenDisplayLargeTextStyle,
    displayMedium: _lightScreenDisplayMediumTextStyle,
    displaySmall: _lightScreenDisplaySmallTextStyle,
    labelSmall: _lightScreenLabelSmallTextStyle,
  );

  static const TextStyle _lightScreenDisplayLargeTextStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: _lightOnPrimaryColor,
    fontFamily: "Roboto",
  );

  static const TextStyle _lightScreenDisplayMediumTextStyle = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: _lightOnPrimaryColor,
    fontFamily: "Roboto",
  );

  static const TextStyle _lightScreenDisplaySmallTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: _lightOnPrimaryColor,
    fontFamily: "Roboto",
    letterSpacing: 1.2,
    height: 1.2,
  );

  static const TextStyle _lightScreenLabelSmallTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: _lightPrimaryColor,
    fontFamily: "Roboto",
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _darkScreenDisplayLargeTextStyle,
    displayMedium: _darkScreenDisplayMediumTextStyle,
    displaySmall: _darkScreenDisplaySmallTextStyle,
    labelSmall: _darkScreenLabelSmallTextStyle,
  );

  static final TextStyle _darkScreenDisplayLargeTextStyle =
      _lightScreenDisplayLargeTextStyle.copyWith(color: _darkOnPrimaryColor);

  static final TextStyle _darkScreenDisplayMediumTextStyle =
      _lightScreenDisplayMediumTextStyle.copyWith(color: _darkOnPrimaryColor);

  static final TextStyle _darkScreenDisplaySmallTextStyle =
      _lightScreenDisplaySmallTextStyle.copyWith(color: _darkOnPrimaryColor);

  static final TextStyle _darkScreenLabelSmallTextStyle =
      _lightScreenLabelSmallTextStyle.copyWith(color: _darkPrimaryColor);
}
