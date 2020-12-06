import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class TagButton extends StatelessWidget {
  final bool isSelected;
  final String tag;
  final VoidCallback onTap;
  const TagButton({
    @required this.isSelected,
    @required this.tag,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomTheme.of(context).colors.primaryColor
              : CustomTheme.of(context).colors.backgroundColor,
          border:
              Border.all(color: CustomTheme.of(context).colors.primaryColor),
          borderRadius: BorderRadius.circular(20.toWidth),
        ),
        child: Center(
          child: Text(
            tag,
            style: CustomTheme.of(context).textStyles.body2.copyWith(
                  color: isSelected
                      ? CustomTheme.of(context).colors.backgroundColor
                      : CustomTheme.of(context).colors.primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}
