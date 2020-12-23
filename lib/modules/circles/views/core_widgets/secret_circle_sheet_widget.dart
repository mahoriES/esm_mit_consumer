import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SecretCircleBottomSheet extends StatefulWidget {
  final Function(String) onAddCircle;

  const SecretCircleBottomSheet({Key key, this.onAddCircle}) : super(key: key);

  @override
  _SecretCircleBottomSheetState createState() =>
      _SecretCircleBottomSheetState();
}

class _SecretCircleBottomSheetState extends State<SecretCircleBottomSheet> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: SizeConfig.screenWidth,
        height: 180 / 595 * SizeConfig.screenHeight +
            MediaQuery.of(context).viewInsets.bottom,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CustomTheme.of(context).colors.backgroundColor),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.widgetPadding,
            vertical: AppSizes.widgetPadding),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: tr('circle.enter_code'),
                hintStyle: CustomTheme.of(context)
                    .themeData
                    .textTheme
                    .subtitle1
                    .copyWith(
                    color:
                    CustomTheme.of(context).colors.disabledAreaColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).colors.shadowColor16),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).colors.secondaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                widget.onAddCircle(_textEditingController.text.toUpperCase());
                Navigator.pop(context);
              },
              child: Container(
                height: 42.toHeight,
                decoration: BoxDecoration(
                    color: CustomTheme.of(context).colors.secondaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: CustomTheme.of(context).colors.backgroundColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}