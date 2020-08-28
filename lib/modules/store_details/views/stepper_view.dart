import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:easy_localization/easy_localization.dart';


class CSStepper extends StatelessWidget {
  final String value;
  final Function didPressAdd;
  final Function didPressRemove;
  final Color backgroundColor;
  const CSStepper(
      {Key key,
        this.didPressAdd,
        this.didPressRemove,
        this.value,
        this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 73,
      decoration: BoxDecoration(
        color: this.backgroundColor ?? AppColors.icColors,
        borderRadius: BorderRadius.circular(100),
      ),
      child: value.contains(tr("new_changes.add"))
          ? InkWell(
        onTap: () {
          didPressAdd();
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
//      crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                didPressRemove();
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
                didPressAdd();
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