import 'package:flutter/widgets.dart';

class SizeConfig {
  SizeConfig._();
  static SizeConfig _instance = SizeConfig._();
  factory SizeConfig() => _instance;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  double refHeight;
  double refWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    refHeight = 667;
    refWidth = 375;
  }

  double getWidthRatio(double val) {
    double res = (val / refWidth);
    double temp = res * screenWidth;
    return temp;
  }

  double getHeightRatio(double val) {
    double res = (val / refHeight);
    double temp = res * screenHeight;
    return temp;
  }

  double getFontRatio(double val) {
    return val;
    double res = (val / refWidth);
    double temp = 0.0;
    if (screenWidth < screenHeight) {
      temp = res * screenWidth;
    } else {
      temp = res * screenHeight;
    }
    return temp;
  }
}

extension SizeUtils on num {
  double get toWidth => SizeConfig().getWidthRatio(this.toDouble());

  double get toHeight => SizeConfig().getHeightRatio(this.toDouble());

  double get toFont => SizeConfig().getFontRatio(this.toDouble());
}
