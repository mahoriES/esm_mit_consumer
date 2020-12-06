import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;
  const ActionButton({
    @required this.text,
    this.icon,
    @required this.onTap,
    @required this.isDisabled,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.toHeight),
          decoration: BoxDecoration(
            color: isDisabled
                ? CustomTheme.of(context).colors.placeHolderColor
                : CustomTheme.of(context).colors.backgroundColor,
            border: isDisabled
                ? null
                : Border.all(
                    color: CustomTheme.of(context).colors.primaryColor,
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
                    color: isDisabled
                        ? CustomTheme.of(context).colors.disabledAreaColor
                        : CustomTheme.of(context).colors.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  child: Text(
                    text,
                    style: CustomTheme.of(context)
                        .textStyles
                        .sectionHeading2
                        .copyWith(
                          color: isDisabled
                              ? CustomTheme.of(context).colors.disabledAreaColor
                              : CustomTheme.of(context).colors.primaryColor,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
