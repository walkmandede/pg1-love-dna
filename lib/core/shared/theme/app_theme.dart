import 'package:flutter/material.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class AppTheme {
  static const Color primary600 = Color(0xFF4DC1AA);
  static const Color ink900 = Color(0xFF13141A);
  static const Color surfaceBlush = Color(0xFFF7F2EF);
  static const Color neutral400 = Color(0xFFA7A7A7);
  static const Color error600 = Color(0xFFDB4B4B);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    // fontFamily: 'Inter',
    fontFamily: 'SFProText',
    primaryColor: primary600,
    scaffoldBackgroundColor: surfaceBlush,
    colorScheme: ColorScheme.light(
      primary: primary600,
      secondary: primary600,
      error: error600,
      background: surfaceBlush,
      onBackground: ink900,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 34 / 28,
        color: ink900,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 28 / 22,
        color: ink900,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 22 / 16,
        color: ink900,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 18 / 14,
        color: neutral400,
      ),
    ),
    primarySwatch: MaterialColor(
      AppColor.primary.toARGB32(),
      {
        50: Color(0xFFE8E9F1),
        100: Color(0xFFC5C7DC),
        200: Color(0xFF9EA2C4),
        300: Color(0xFF777DAC),
        400: Color(0xFF5A6099),
        500: Color(0xFF3C3D80),
        600: Color(0xFF353675),
        700: Color(0xFF2D2E68),
        800: Color(0xFF26275B),
        900: Color(0xFF191A44),
      },
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.buttonBase,
      splashColor: AppColor.buttonBase,
    ),
    primaryTextTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    ),
  );
}
