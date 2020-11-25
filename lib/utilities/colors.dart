import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';

///Removing the deprecation of this class. This class SHOULD NOT BE USED for Text Widgets,
///
///however, this shall be used for background, foreground, other decoration properties.
///
///It provides the benefit of using the [const] constructor, hence when rebuilding the widget tree,
///
///widgets using this won't be rebuilt and we get performance gain. Similarly goes for [AppSizes] class.
///
//TODO: Remove colors which are no longer required post implementation of the new designs, and which pertain only to text colors.

class AppColors {
  static const mainColor = Color(0xff4093d1);
  static const darkGrey = Color(0xff989696);
  static const orange = Color(0xffeb730c);
  static const offWhite = Color.fromRGBO(235, 236, 235, 1.0);
  static const solidWhite = Color(0xffffffff);
  static const offWhitish = const Color(0xfff0f2f6);
  static const icColors = Color(0xff5f3a9f);
  static const iconColors = Color(0xffd5133a);
  static const separatorColor = Color.fromRGBO(0, 0, 0, 0.2);
  static const blackShadowColor = Color.fromRGBO(0, 0, 0, 0.12);
  static const solidBlack = Color.fromRGBO(0, 0, 0, 0.87);
  static const greyishText = const Color(0xff808080);
  static const lightBlue = const Color(0xff5091cd);
  static const offGreyish = const Color(0xff515c6f);
  static const hotPink = const Color(0xffe1517d);

  ///New colors to be used in the UI for building the new designs

  static const blueBerry = const Color(0xff5f3a9f);
  static const darkishPink = const Color(0xffe1517d);
  static const lightKhakhi = const Color(0xfffaf2dc);
  static const greyedout = const Color(0xffe4e4e4);
  static const green = const Color(0xff2ac10f);
  static const black = const Color(0xff363636);
  static const blackTwo = const Color(0xff393939);
  static const warmGrey = const Color(0xff7c7c7c);

  static const linearGradient = LinearGradient(
      begin: Alignment(0.27639952301979065, 0.5),
      end: Alignment(0.980859398841858, 0.5),
      colors: [const Color(0xff5f3a9f), const Color(0xff5f3a9f)]);
}
