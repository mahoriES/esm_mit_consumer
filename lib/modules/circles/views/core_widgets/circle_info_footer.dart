import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

///
/// This footer is shown at the bottom of the circle screen. It provides
/// info regarding the circles. A brief definition of circles. Apart
/// from that this also has the embedded secret circles feature. Tapping on "eSamudaay Circles" thrice
/// makes you an advanced user and you can then
///

class CircleInfoFooter extends StatefulWidget {
  final Function onTapCallBack;

  const CircleInfoFooter({@required this.onTapCallBack});

  @override
  _CircleInfoFooterState createState() => _CircleInfoFooterState();
}

class _CircleInfoFooterState extends State<CircleInfoFooter> {
  bool _isAdvancedUser;
  int tapCount;

  @override
  void initState() {
    checkAdvancedUser();
    tapCount = 0;
    super.initState();
  }

  void checkAdvancedUser() async {
    debugPrint('Check advance user called');
    final prefs = await SharedPreferences.getInstance();
    try {
      final bool isAdvancedUser = prefs.getBool('isAdvancedUser');
      _isAdvancedUser = isAdvancedUser ?? false;
    } catch (e) {
      debugPrint('Catch block called');
      _isAdvancedUser = false;
      prefs.setBool('isAdvancedUser', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: secretCodeActionHandler,
            child: Text(
              'circle.branding',
              style: CustomTheme.of(context).textStyles.topTileTitle.copyWith(
                  color: CustomTheme.of(context).colors.disabledAreaColor),
            ).tr(),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'circle.info_1',
            style: CustomTheme.of(context).textStyles.sectionHeading1.copyWith(fontWeight: FontWeight.w400,
                color: CustomTheme.of(context).colors.disabledAreaColor),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 30,
          ),
          Text(
            'circle.info_2',
            style: CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                color: CustomTheme.of(context).colors.disabledAreaColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void secretCodeActionHandler() async {
    if (_isAdvancedUser) {
      widget.onTapCallBack();
    } else {
      tapCount++;
      if (tapCount % 3 == 0) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAdvancedUser', true);
        _isAdvancedUser = true;
        widget.onTapCallBack();
      }
    }
  }
}