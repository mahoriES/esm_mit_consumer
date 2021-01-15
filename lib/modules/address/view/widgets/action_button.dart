import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

/// A generic button with custom background color, text color, text style , border and icon.

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color textColor;
  final Color buttonColor;
  final bool isFilled;
  final bool showBorder;
  final TextStyle textStyle;
  const ActionButton({
    @required this.text,
    this.icon,
    @required this.onTap,
    this.isDisabled = false,
    this.textColor,
    this.buttonColor,
    this.isFilled = false,
    this.showBorder = true,
    this.textStyle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _tempButtonColor = !showBorder
        ? Colors.transparent
        : isDisabled
            ? CustomTheme.of(context).colors.placeHolderColor
            : (buttonColor ?? CustomTheme.of(context).colors.primaryColor);

    final Color _tempTextColor = isDisabled
        ? CustomTheme.of(context).colors.disabledAreaColor
        : (textColor ?? CustomTheme.of(context).colors.primaryColor);

    final Color _tempBackgroundColor = isDisabled
        ? CustomTheme.of(context).colors.placeHolderColor
        : isFilled
            ? (buttonColor ?? CustomTheme.of(context).colors.primaryColor)
            : CustomTheme.of(context).colors.backgroundColor;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.toHeight),
          decoration: BoxDecoration(
            color: _tempBackgroundColor,
            border: Border.all(
              color: _tempButtonColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Flexible(
                  child: Icon(
                    icon,
                    color: _tempTextColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  child: Text(
                    text,
                    style: (textStyle ??
                            CustomTheme.of(context).textStyles.sectionHeading2)
                        .copyWith(color: _tempTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
