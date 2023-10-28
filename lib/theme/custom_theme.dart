import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class CustomTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: 10.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: Palette.neutral[120],
      ),
    ),
  );

  static NavigationBarThemeData lightNavigationBarTheme =
      NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Colors.transparent,
    elevation: 0,
    shadowColor: Colors.transparent,
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return TextStyle(
            color: Palette.russianViolet[100], // Color for selected labels
            fontWeight: FontWeight.w700, // Font weight for selected labels
          );
        } else {
          return TextStyle(
            color: Palette.neutral[50], // Color for unselected labels
          );
        }
      },
    ),
  );

  static ThemeData lightTheme(
    BuildContext context,
  ) =>
      ThemeData(
        brightness: Brightness.light,
        textTheme: lightTextTheme,
        colorSchemeSeed: Palette.neutral[100],
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
        navigationBarTheme: lightNavigationBarTheme,
        useMaterial3: true,
      );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: 10.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: Palette.neutral[30],
      ),
    ),
  );

  static ThemeData darkTheme(
    BuildContext context,
  ) =>
      ThemeData(
        brightness: Brightness.dark,
        textTheme: darkTextTheme,
        colorSchemeSeed: Palette.neutral[100],
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
        useMaterial3: true,
      );
}

double getFontHeight(double fontSize, double pixelsHeight) {
  return pixelsHeight / fontSize;
}

extension KumulyAttributes on TextTheme {
  TextStyle caption1(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 10.0,
        fontWeight: fontWeight,
        height: getFontHeight(10.0, 12.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display1(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 12.0,
        fontWeight: fontWeight,
        height: getFontHeight(12.0, 14.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display2(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 14.0,
        fontWeight: fontWeight,
        height: getFontHeight(14.0, 18.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display3(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 16.0,
        fontWeight: fontWeight,
        height: getFontHeight(16.0, 20.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display4(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 18.0,
        fontWeight: fontWeight,
        height: getFontHeight(18.0, 22.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display5(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 20.0,
        fontWeight: fontWeight,
        height: getFontHeight(20.0, 24.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display6(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 24.0,
        fontWeight: fontWeight,
        height: getFontHeight(24.0, 28.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display7(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 32.0,
        fontWeight: fontWeight,
        height: getFontHeight(32.0, 40.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display8(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 40.0,
        fontWeight: fontWeight,
        height: getFontHeight(40.0, 48.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display8_5(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 48.0,
        fontWeight: fontWeight,
        height: getFontHeight(40.0, 48.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display9(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 56.0,
        fontWeight: fontWeight,
        height: getFontHeight(56.0, 64.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle display10(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 80.0,
        fontWeight: fontWeight,
        height: getFontHeight(80.0, 72.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle body1(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 10.0,
        fontWeight: fontWeight,
        height: getFontHeight(10.0, 16.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle body2(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 12.0,
        fontWeight: fontWeight,
        height: getFontHeight(12.0, 18.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle body3(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 14.0,
        fontWeight: fontWeight,
        height: getFontHeight(14.0, 20.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle body4(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 16.0,
        fontWeight: fontWeight,
        height: getFontHeight(16.0, 24.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle body5(
    Color? color,
    FontWeight fontWeight, {
    double wordSpacing = 10.0,
    double? letterSpacing,
  }) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 18.0,
        fontWeight: fontWeight,
        height: getFontHeight(18.0, 28.0),
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
      );

  TextStyle header(
    Color? color,
  ) =>
      bodyLarge!.copyWith(
        color: color,
        fontSize: 10.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        height: getFontHeight(10.0, 12.0),
      );
}
