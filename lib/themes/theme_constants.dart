part of 'package:eSamudaay/themes/custom_theme.dart';

// class contains all the colors needed throughout the app.
// add more colors here if needed and also override new colors in extended classes.
abstract class _AppThemeColors {
  Color get primaryColor;
  Color get secondaryColor;
  Color get placeHolderColor;
  Color get backgroundColor;
  Color get positiveColor;
  Color get textColor;
  Color get textColorDarker;
  Color get disabledAreaColor;
  Color get warningColor;
  Color get shadowColor;
  Brightness get brightness;
}

// define all the font families used throughout the app.
class _AppFontFamily {
  static const String archivo = "Archivo";
  static const String avenir = "Avenir";
  static const String lato = "Lato";
}

// text styles should be similar in all themes except the text color.
// pass significant AppThemeColors to get respective text styles.
class _AppTextStyles {
  final _AppThemeColors themeColors;
  _AppTextStyles(this.themeColors);

  TextStyle get merchantCardTitle => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 24.toFont,
        fontWeight: FontWeight.w700,
        fontFamily: _AppFontFamily.archivo,
      );

  TextStyle get topTileTitle => TextStyle(
        color: themeColors.textColor,
        fontSize: 20.toFont,
        fontWeight: FontWeight.w500,
        fontFamily: _AppFontFamily.archivo,
        height: 1.1,
      );

  TextStyle get sectionHeading1 => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 16.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.archivo,
      );

  TextStyle get sectionHeading2 => TextStyle(
        color: themeColors.textColor,
        fontSize: 16.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.18,
      );

  TextStyle get cardTitle => TextStyle(
        color: themeColors.textColor,
        fontSize: 14.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.21,
      );

  TextStyle get body1 => TextStyle(
        color: themeColors.textColor,
        fontSize: 12.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.25,
      );

  TextStyle get body1Faded => body1.copyWith(
        color: themeColors.disabledAreaColor,
      );

  TextStyle get buttonText2 => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 10.toFont,
        fontWeight: FontWeight.w700,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get body2 => TextStyle(
        color: themeColors.textColorDarker,
        fontSize: 10.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get body2Faded => body2.copyWith(
        color: themeColors.disabledAreaColor,
      );

  TextStyle get body2Secondary => body2.copyWith(
        color: themeColors.secondaryColor,
      );

  TextStyle get bottomMenu => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 10.toFont,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );
}

// extension to get colors for light theme.
class _LightThemeColors with _AppThemeColors {
  @override
  Color get primaryColor => const Color(0xFF5f3a9f); // brandviolet
  @override
  Color get secondaryColor => const Color(0xFFe1517d); // brandpink
  @override
  Color get positiveColor => const Color(0xFF2ac10f); // positivegreen
  @override
  Color get textColor => const Color(0xFF363636); // dark black
  @override
  Color get textColorDarker => const Color(0xFF000000); // pure black
  @override
  Color get disabledAreaColor => const Color(0xFF969696); // dark grey
  @override
  Color get placeHolderColor => const Color(0xFFe4e4e4); // light grey
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF); // pure white
  @override
  Color get warningColor => const Color(0xFFfb7452); // brandorange
  @override
  Color get shadowColor => const Color(0x0d242424);

  @override
  Brightness get brightness => Brightness.light;
}
