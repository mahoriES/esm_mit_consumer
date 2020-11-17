import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/theme_constants/theme_constants.dart';

class ThemeGlobals {
  static AppThemeColors get customColors => store.state.customTheme.colors;
  static AppTextStyles get customTextStyles =>
      store.state.customTheme.textStyles;
}

// using theme in app =>

// 1. color : ThemeGlobals.customColors.primaryColor
// 2. style : ThemeGlobals.customTextStyles.headline6
// 3. appBarTheme : Theme.of(context).appBarTheme
