import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class NoItemsFoundView extends StatelessWidget {
  const NoItemsFoundView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                width: SizeConfig.screenWidth,
                height: 150.toHeight,
                color: CustomTheme.of(context).colors.shadowColor,
              ),
              clipper: CustomClipPath(),
            ),
            Positioned(
              bottom: 20.toHeight,
              right: SizeConfig.screenWidth * 0.15,
              child: Image.asset(
                ImagePathConstants.emptyBagImage,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(height: 50.toHeight),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.toWidth),
          child: Text(
            'screen_order.empty_pro_hint',
            style: CustomTheme.of(context).textStyles.cardTitle,
            textAlign: TextAlign.center,
          ).tr(),
        ),
        SizedBox(height: 30.toHeight),
      ],
    );
  }
}
