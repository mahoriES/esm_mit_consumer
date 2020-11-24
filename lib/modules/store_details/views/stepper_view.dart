import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO : This should a local component in product_count_widget.

///CSStepper class represents the stepper button being used in the app
///It is used to increment or decrement the selected quantity of any item

class CSStepper extends StatelessWidget {
  // count represents the ni=umber of items present in the cart for this partiular product.
  final int count;

  // There are only two variation of CSStepper used across the app.
  // one with blueBerry background => fillColor = true.
  // second with white background => fillColor = false.
  final bool fillColor;

  // isDisables is true in case the item is unavailable for some reason.
  final bool isDisabled;

  final Function addButtonAction;
  final Function removeButtonAction;
  const CSStepper({
    Key key,
    @required this.count,
    @required this.isDisabled,
    @required this.fillColor,
    @required this.addButtonAction,
    @required this.removeButtonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get background and text colors according to fillClor value
    Color _bgColor = fillColor
        ? CustomTheme.of(context).colors.primaryColor
        : CustomTheme.of(context).colors.backgroundColor;
    Color _textColor = fillColor
        ? CustomTheme.of(context).colors.backgroundColor
        : CustomTheme.of(context).colors.primaryColor;

    return Container(
      height: 30.toHeight,
      width: 73.toWidth,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _textColor, width: 1),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.toWidth,
        vertical: 8.toHeight,
      ),
      child: count == 0
          // If count is 0 then show button with "+" option only.
          ? InkWell(
              onTap: () {
                isDisabled
                    ? Fluttertoast.showToast(msg: 'Item not in stock!')
                    : addButtonAction();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Icon(
                      Icons.add,
                      color: _textColor,
                      size: 15.toFont,
                    ),
                  ),
                  SizedBox(width: 4.toWidth),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        tr("new_changes.add"),
                        style: CustomTheme.of(context)
                            .textStyles
                            .cardTitle
                            .copyWith(color: _textColor),
                      ),
                    ),
                  ),
                ],
              ),
            )
          // If count is > 0 then show button with both "+" and "-" option.
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: InkWell(
                    onTap: () {
                      isDisabled
                          ? Fluttertoast.showToast(msg: 'Item not in stock!')
                          : removeButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.remove,
                        color: _textColor,
                        size: 15.toFont,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.toWidth),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      count.toString(),
                      style: CustomTheme.of(context)
                          .textStyles
                          .cardTitle
                          .copyWith(color: _textColor),
                    ),
                  ),
                ),
                SizedBox(width: 4.toWidth),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      isDisabled
                          ? Fluttertoast.showToast(msg: 'Item not in stock!')
                          : addButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.add,
                        color: _textColor,
                        size: 15.toFont,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
