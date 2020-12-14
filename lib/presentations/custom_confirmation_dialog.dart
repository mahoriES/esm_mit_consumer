import 'package:eSamudaay/presentations/custom_icon_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButtonText;
  final String negativeButtonText;
  final VoidCallback positiveAction;
  final Color actionButtonColor;
  const CustomConfirmationDialog({
    @required this.title,
    @required this.message,
    @required this.positiveAction,
    @required this.positiveButtonText,
    this.negativeButtonText,
    this.actionButtonColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.toWidth),
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 60.toHeight),
              if (title != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 46.toWidth),
                  child: Text(
                    title,
                    style: CustomTheme.of(context)
                        .textStyles
                        .topTileTitle
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 16.toHeight),
              ],
              if (message != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.toWidth),
                  child: Text(
                    message,
                    style: CustomTheme.of(context).textStyles.cardTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25.toHeight),
              ],
              Row(
                children: [
                  // Negative button is not required as some of the dialogues may not have it in design.
                  if (negativeButtonText != null) ...[
                    Expanded(
                      child: CustomIconButton(
                        icon: Icons.clear,
                        text: negativeButtonText,
                        // Negative action is defined by default.
                        // If it's needed to be dynamic in future , please create a parameter for this
                        // and pass default value as Navigator.pop(context)
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                  Expanded(
                    child: CustomIconButton(
                      icon: Icons.check,
                      text: positiveButtonText,
                      onTap: positiveAction,
                      color: actionButtonColor ??
                          CustomTheme.of(context).colors.positiveColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
