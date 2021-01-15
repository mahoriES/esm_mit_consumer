import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FeedbackSubmissionDialog extends StatelessWidget {
  const FeedbackSubmissionDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 60),
              Image.asset(
                ImagePathConstants.appLogo,
                height: 42,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 35),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 46),
                child: Text(
                  tr("screen_order_feedback.feedback_dialog_title"),
                  style: CustomTheme.of(context)
                      .textStyles
                      .topTileTitle
                      .copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  tr("screen_order_feedback.feedback_dialog_message"),
                  style: CustomTheme.of(context).textStyles.cardTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
