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
  Color get brandViolet;
  Color get brandPink;
  Color get positiveGreen;
  Color get darkBlack;
  Color get pureBlack;
  Color get darkGrey;
  Color get lightGrey;
  Color get pureWhite;
  Color get brandOrange;
  Color get categoryTileTextUnderlay;
  Brightness get brightness;
}

// define all the font families used throughout the app.
class _AppFontFamily {
  static const String archivo = "Archivo";
  //static const String avenir = "Avenir";
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
  Color get primaryColor => brandViolet;
  @override
  Color get secondaryColor => brandPink;
  @override
  Color get positiveColor => positiveGreen;
  @override
  Color get textColor => darkBlack;
  @override
  Color get textColorDarker => pureBlack;
  @override
  Color get disabledAreaColor => darkGrey;
  @override
  Color get placeHolderColor => lightGrey;
  @override
  Color get backgroundColor => pureWhite;
  @override
  Color get warningColor => brandOrange;
  @override
  Color get shadowColor => const Color(0x0d242424);
  @override
  Color get brandViolet => const Color(0xFF5f3a9f);
  @override
  Color get brandPink => const Color(0xFFe1517d);
  @override
  Color get positiveGreen => const Color(0xFF2ac10f);
  @override
  Color get darkBlack => const Color(0xFF363636);
  @override
  Color get pureBlack => const Color(0xFF000000);
  @override
  Color get darkGrey => const Color(0xFF969696);
  @override
  Color get lightGrey => const Color(0xFFe4e4e4);
  @override
  Color get pureWhite => const Color(0xFFFFFFFF);
  @override
  Color get brandOrange => const Color(0xFFfb7452);
  @override
  Color get categoryTileTextUnderlay => const Color(0xffe6ffffff);
  @override
  Brightness get brightness => Brightness.light;
}
