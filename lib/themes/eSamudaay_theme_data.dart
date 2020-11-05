import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';

class AppThemeData {

  static const _lightFillColor = AppColors.solidBlack;

  static const _darkFillColor = AppColors.solidWhite;

  static final Color _lightFocusColor = AppColors.solidBlack.withOpacity(0.12);

  static final Color _darkFocusColor = AppColors.solidWhite.withOpacity(0.12);

  static ThemeData lightThemeData =
  themeData(defaultColorScheme, _lightFocusColor);

  ///The [darkThemeData] variable holds the [ThemeData] instance for dark mode
  ///
  ///static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  ///To use dark mode theme, uncomment above and specify values for [darkModeColorScheme]
  ///
  static const _regular = FontWeight.w400;

  static const _medium = FontWeight.w500;

  static const _semiBold = FontWeight.w600;

  static const _bold = FontWeight.w700;

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      ///The [primarySwatch] requires an AccentColor, hence this shall be changes later, when that is available
      primarySwatch: Colors.purple,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      fontFamily: 'JTLeonor',
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: AppColors.solidWhite,
        brightness: Brightness.light,
      ),
    );
  }

  ///The [defaultColorScheme] specifies the light/white [ColorScheme] to be used. It is the default theme mode.
  static const ColorScheme defaultColorScheme = ColorScheme(
      primary: AppColors.solidWhite,
      primaryVariant: AppColors.offWhitish,
      secondary: AppColors.blueBerry,
      secondaryVariant: AppColors.greyedout,
      surface: AppColors.solidWhite,
      background: AppColors.solidWhite,
      error: _lightFillColor,
      onPrimary: _lightFillColor,
      onSecondary: AppColors.solidWhite,
      onSurface: AppColors.offWhitish,
      onBackground: AppColors.offWhitish,
      onError: _lightFillColor,
      brightness: Brightness.light);

  ///The [darkModeColorScheme] should be assigned to a custom instance of [ColorScheme] if you wish
  ///to apply a dark mode theme to the app.
  ///
  /// static const ColorScheme darkModeColorScheme = ColorScheme.dark();
  ///
  ///With [defaultColorScheme] and [darkModeColorScheme] specified
  ///you may obtain the appropriate [ThemeData] by passing the required [ColorScheme] value as the function parameter.

  static final TextTheme _textTheme = TextTheme(
    headline6: TextStyle(
        color: AppColors.black,
        fontSize: AppSizes.itemHeadingFontSize.toFont,
        fontWeight: _medium),
    subtitle1: TextStyle(
        color: AppColors.blackTwo,
        fontSize: AppSizes.itemSubtitle1FontSize.toFont,
        fontWeight: _regular),
    subtitle2: TextStyle(
        color: AppColors.blackTwo,
        fontSize: AppSizes.itemSubtitle2FontSize.toFont,
        fontWeight: _regular),
    caption: TextStyle(
        color: AppColors.black,
        fontSize: AppSizes.itemCaptionFontSize,
        fontWeight: _regular),
    bodyText1: TextStyle(
        color: AppColors.blueBerry,
        fontSize: AppSizes.bodyText1FontSize.toFont,
        fontWeight: _regular),
    bodyText2: TextStyle(
        color: AppColors.warmGrey,
        fontSize: AppSizes.bodyText2FontSize.toFont,
        fontWeight: _regular),
  );
}
