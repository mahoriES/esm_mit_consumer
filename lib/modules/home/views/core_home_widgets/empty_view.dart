import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

//TODO: Merge this and no product view into a common customisable widget for such cases

class EmptyListView extends StatelessWidget {

  const EmptyListView();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: CustomTheme.of(context).colors.backgroundColor,
                  ),
                  clipper: CustomClipPath(),
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    'assets/images/clipart.png',
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text('',
              style: const TextStyle(
                  color: const Color(0xff1f1f1f),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Avenir-Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
              textAlign: TextAlign.left)
              .tr(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text('No Shops Found',
                maxLines: 2,
                style: const TextStyle(
                    color: const Color(0xff6f6d6d),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Avenir-Medium",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.center)
                .tr(),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
