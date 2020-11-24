import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class SearchComponent extends StatelessWidget {
  final String placeHolder;
  final bool isEnabled;
  final TextEditingController controller;
  final Function onTapIfDisabled;
  const SearchComponent({
    @required this.placeHolder,
    @required this.isEnabled,
    @required this.controller,
    @required this.onTapIfDisabled,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? null : onTapIfDisabled,
      child: TextField(
        enabled: isEnabled,
        controller: controller,
        style: CustomTheme.of(context).textStyles.sectionHeading2,
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: CustomTheme.of(context).colors.primaryColor,
          ),
          hintText: placeHolder,
          hintStyle: CustomTheme.of(context)
              .textStyles
              .sectionHeading2
              .copyWith(
                  color: CustomTheme.of(context).colors.disabledAreaColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: new BorderSide(
              color: CustomTheme.of(context).colors.placeHolderColor,
            ),
          ),
        ),
      ),
    );
  }
}
