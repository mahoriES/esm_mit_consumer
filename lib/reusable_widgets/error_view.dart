import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class GenericErrorView extends StatelessWidget {
  final VoidCallback retry;
  const GenericErrorView(this.retry, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
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
            'common.some_error_occured',
            style: CustomTheme.of(context).textStyles.cardTitle,
            textAlign: TextAlign.center,
          ).tr(),
        ),
        SizedBox(height: 20.toHeight),
        InkWell(
          onTap: retry,
          child: Icon(Icons.refresh),
        ),
      ],
    );
  }
}
