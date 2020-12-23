import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

///
///This view is shown when user does not allow location or location is disabled
///It shows info regarding why is location essential as well as a button to enable
///the same. Upon tapping, user is taken to app settings page where they can allow/enable location.
///

class LocationDisabledView extends StatelessWidget {
  ///
  /// This callback is invoked when user taps on the button to enable/allow location
  ///
  final VoidCallback onTapLocationAction;

  const LocationDisabledView({Key key, @required this.onTapLocationAction})
      : assert(onTapLocationAction != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'circle.location',
              textAlign: TextAlign.center,
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading2
                  .copyWith(
                  color: CustomTheme.of(context).colors.disabledAreaColor),
            ).tr(),
          ),
          const SizedBox(
            height: AppSizes.widgetPadding,
          ),
          InkWell(
            onTap: onTapLocationAction,
            child: Container(
              padding:
              EdgeInsets.symmetric(vertical: AppSizes.separatorPadding),
              width: 234 / 375 * SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                    width: 1.5,
                    color: CustomTheme.of(context).colors.primaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePathConstants.locationPointerImage,
                    color: CustomTheme.of(context).colors.primaryColor,
                  ),
                  const SizedBox(
                    width: AppSizes.separatorPadding / 2,
                  ),
                  Text(
                    'circle.turn_on',
                    style: CustomTheme.of(context).textStyles.sectionHeading1,
                  ).tr(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}