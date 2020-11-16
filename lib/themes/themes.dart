import 'package:eSamudaay/themes/theme_constants/theme_constants.dart';
import 'package:flutter/material.dart';

// To Create a new Theme =>

// 1.  Add a new Value in enum THEME_TYPES. e.g. enum THEME_TYPES { LIGHT , DARK }

// 2.  Create a new color class extending AppThemeColors. e.g. DarkThemeColors
// class DarkThemeColors with AppThemeColors {
//   @override
//   Color get primaryColor => const Color()
//   ....
//   @override
//   Brightness get brightness => Brightness.dark;
// }

// 3.  Update theme as
// state.copyWith(themeData : CustomThemes(THEME_TYPES.DARK))

class CustomThemes {
  // Creating custom colorScheme and textTheme
  // so that , we can use more meaningful names for colors and textstyles defined in theme data.
  // also we can avoid overriding the old screen's style variables while using dynamic values for new screens.
  AppThemeColors colors;
  AppTextStyles textStyles;
  ThemeData themeData;

  CustomThemes(THEME_TYPES themeTypes) {
    // for now there is only one theme that's why passed the LightThemeColors direclty.
    // otherwise check the themeTypes and pass the AppThemeColors accordingly.
    colors = LightThemeColors();

    // pass the above color in AppTextStyles to get respective textTheme.
    textStyles = AppTextStyles(colors);

    // defining text theme so that some styles can be defined globally . e.g. appBarTheme, cardTheme etc.
    themeData = ThemeData(
      brightness: colors.brightness,
      appBarTheme: AppBarTheme(
        color: colors.backgroundColor,
        iconTheme: IconThemeData(
          color: colors.primaryColor,
        ),
      ),
    );
  }
}

// Add a new value here for each new theme.
enum THEME_TYPES { LIGHT }
