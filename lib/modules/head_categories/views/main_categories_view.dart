import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class BusinessesListUnderSelectedCategoryScreen extends StatefulWidget {


  @override
  _BusinessesListUnderSelectedCategoryScreenState createState() =>
      _BusinessesListUnderSelectedCategoryScreenState();
}

class _BusinessesListUnderSelectedCategoryScreenState
    extends State<BusinessesListUnderSelectedCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: " ",
              style: CustomTheme.of(context).textStyles.topTileTitle,
              children: <TextSpan>[
                TextSpan(
                  text: ' ',
                  style: CustomTheme.of(context).textStyles.body1,
                ),
              ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CustomTheme.of(context).colors.brandViolet,
          ),
          onPressed: () {
          },
        ),
      ),
    );
  }
}
