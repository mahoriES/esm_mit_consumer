import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CupertinoStyledBackButton extends StatelessWidget {
  final Function onPressed;

  const CupertinoStyledBackButton({Key key, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onPressed();},
      child: Container(
        color: CustomTheme.of(context)
            .colors
            .backgroundColor,
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 5),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: CustomTheme.of(context)
                  .colors
                  .primaryColor,
            ),
            Text(
              'common.back',
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading1,
            ).tr(),
          ],
        ),
      ),
    );
  }
}
