part of 'package:eSamudaay/themes/custom_theme.dart';

// class contains all the colors needed throughout the app.
// add more colors here if needed and also override new colors in extended classes.
abstract class _AppThemeColors {
  Color get primaryColor;
  Color get secondaryColor;
  Color get placeHolderColor;
  Color get backgroundColor;
  Color get highlightColor;
  Color get textColor1;
  Color get textColor2;
  Color get disabledAreaColor;
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

  TextStyle get headline6 => TextStyle(
        color: themeColors.textColor1,
        fontSize: 20.toFont,
        fontWeight: FontWeight.w500,
        fontFamily: _AppFontFamily.archivo,
        height: 1.1,
      );

  TextStyle get subtitle1 => TextStyle(
        color: themeColors.textColor2,
        fontSize: 16.toFont,
        fontWeight: FontWeight.normal,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get subtitleDisabled =>
      subtitle1.copyWith(color: themeColors.disabledAreaColor);

  TextStyle get subtitle2 => subtitle1.copyWith(fontSize: 14.toFont);

  TextStyle get caption => TextStyle(
        color: themeColors.textColor1,
        fontSize: 10.toFont,
        fontWeight: FontWeight.normal,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get menuActive => caption.copyWith(color: themeColors.primaryColor);

  TextStyle get menuDefault =>
      caption.copyWith(color: themeColors.disabledAreaColor);
}

// extension to get colors for light theme.
class _LightThemeColors with _AppThemeColors {
  @override
  Color get primaryColor => const Color(0xFF5f3a9f); // blueBerry
  @override
  Color get secondaryColor => const Color(0xFFe1517d); // darkish Pink
  @override
  Color get placeHolderColor => const Color(0xFFe4e4e4); // greyed out
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF); // white
  @override
  Color get highlightColor => const Color(0xFF2ac10f); // green
  @override
  Color get textColor1 => const Color(0xFF363636); // dark black
  @override
  Color get textColor2 => const Color(0xFF393939); // black two
  @override
  Color get disabledAreaColor => const Color(0xFF7c7c7c); // warm grey
  @override
  Brightness get brightness => Brightness.light;
}

class _DarkThemeColors with _AppThemeColors {
  @override
  Color get primaryColor => const Color(0xFF000000); // blueBerry
  @override
  Color get secondaryColor => const Color(0xFF555555); // darkish Pink
  @override
  Color get placeHolderColor => const Color(0xFF888888); // greyed out
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF); // white
  @override
  Color get highlightColor => const Color(0xFF2ac10f); // green
  @override
  Color get textColor1 => const Color(0xFF363636); // black
  @override
  Color get textColor2 => const Color(0xFF393939); // black two
  @override
  Color get disabledAreaColor => const Color(0xFF7c7c7c); // warm grey
  @override
  Brightness get brightness => Brightness.light;
}
