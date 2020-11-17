import 'package:eSamudaay/themes/theme_constants/theme_globals.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:easy_localization/easy_localization.dart';

///CSStepper class represents the stepper button being used in the app
///It is used to increment or decrement the selected quantity of any item

class CSStepper extends StatelessWidget {

  final String value;
  final Function addButtonAction;
  final Function removeButtonAction;
  // There are two types of CSStepper buttons in design
  // 1. with blueBerry background and wihite text.
  // 2. with white background and blueBerry text.
  // fillColor value should be true in first case and and false in second case.
  final bool fillColor;
  const CSStepper({
    Key key,
    this.addButtonAction,
    this.removeButtonAction,
    this.value,
    this.fillColor = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.toHeight,
      width: 73.toWidth,
      decoration: BoxDecoration(
        color: fillColor
            ? ThemeGlobals.customColors.primaryColor
            : ThemeGlobals.customColors.backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.icColors),
      ),
      child: value.contains(tr("new_changes.add"))
          ? InkWell(
              onTap: () {
                addButtonAction();
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Icon(
                      Icons.add,
                      color: fillColor
                          ? ThemeGlobals.customColors.backgroundColor
                          : ThemeGlobals.customColors.primaryColor,
                      size: 18,
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: fillColor
                            ? ThemeGlobals.customColors.backgroundColor
                            : ThemeGlobals.customColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      removeButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.remove,
                        color: fillColor
                            ? ThemeGlobals.customColors.backgroundColor
                            : ThemeGlobals.customColors.primaryColor,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text(value,
                      style: TextStyle(
                        color: fillColor
                            ? ThemeGlobals.customColors.backgroundColor
                            : ThemeGlobals.customColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Avenir-Medium",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      addButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.add,
                        color: fillColor
                            ? ThemeGlobals.customColors.backgroundColor
                            : ThemeGlobals.customColors.primaryColor,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}