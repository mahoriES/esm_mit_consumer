import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.icColors,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/indicator.gif',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Product by'
                  '\nNirmund Digital Distributions Pvt Ltd',
                  style: TextStyle(
                    color: Color(0xff797979),
                    fontSize: 18,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showCreditDialog(context);
                  },
                  child: Center(
                    child: Text(
                      'Credits',
                      style: CustomTheme.of(context)
                          .textStyles
                          .sectionHeading1Regular
                          .copyWith(
                              decoration: TextDecoration.underline,
                              color:
                                  CustomTheme.of(context).colors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCreditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Credits'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Illustrations designed by Freepik'),
            ],
          ),
        );
      },
    );
  }
}
