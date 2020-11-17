import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:easy_localization/easy_localization.dart';

///CSStepper class represents the stepper button being used in the app
///It is used to increment or decrement the selected quantity of any item

class CSStepper extends StatelessWidget {
  final String value;
  final Function addButtonAction;
  final Function removeButtonAction;
  final Color backgroundColor;
  const CSStepper(
      {Key key,
      this.addButtonAction,
      this.removeButtonAction,
      this.value,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.toHeight,
      width: 73.toWidth,
      decoration: BoxDecoration(
        color: this.backgroundColor ?? AppColors.icColors,
        borderRadius: BorderRadius.circular(100),
      ),
      child: value.contains(tr("new_changes.add"))
          ? InkWell(
              onTap: () {
                addButtonAction();
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(value,
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Avenir-Medium",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                    Spacer(),
                  ],
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      removeButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text(value,
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir-Medium",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      addButtonAction();
                    },
                    child: Container(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
