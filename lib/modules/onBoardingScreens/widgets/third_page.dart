import 'package:flutter/material.dart';

class ThirdPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Image.asset('assets/images/family.png'),
        Spacer(),
        Padding(padding: EdgeInsets.all(10)),
        Column(
          children: [
            SizedBox(
              width: 326.0,
              child: Text(
                'Spend quality time with your loved ones, \nwhile we take care of the rest',
                style: TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 15,
                  color: const Color(0xff5f3a9f),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              width: 28,
              color: Color(0xffe1d5f6),
              height: 2,
            ),
            SizedBox(
              width: 362.0,
              child: Text(
                'ನಿಮ್ಮ ಪ್ರೀತಿಪಾತ್ರರ ಜೊತೆ ಗುಣಮಟ್ಟದ ಸಮಯವನ್ನು \nಕಳೆಯಿರಿ ಉಳಿದದ್ದನ್ನು  ನಾವು ನೋಡಿಕೊಳ್ಳುತ್ತೇವೆ',
                style: TextStyle(
                  fontFamily: 'Baloo Tamma 2',
                  fontSize: 15,
                  color: const Color(0xffe1517d),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Spacer()
      ],
    );
  }
}

Row buildDialogeWidget() {
  return Row(
    children: [
      Spacer(),
      Stack(
        children: [
          Image.asset('assets/images/dialog.png'),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 26,
                    color: const Color(0xff5f3a9f),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 3, bottom: 3),
                  width: 28,
                  color: Color(0xffe1d5f6),
                  height: 2,
                ),
                Text(
                  'ನಮಸ್ಕಾರ!',
                  style: TextStyle(
                    fontFamily: 'Baloo Tamma 2',
                    fontSize: 16,
                    color: const Color(0xffe1517d),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          )
        ],
      ),
      SizedBox(
        width: 30,
      )
    ],
  );
}
