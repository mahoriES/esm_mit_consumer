import 'package:flutter/material.dart';

class SecondPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildDialogeWidget(),
        Spacer(),
        Image.asset('assets/images/esamudayDelivery.png'),
        Spacer(),
        Padding(padding: EdgeInsets.all(10)),
        Column(
          children: [
            SizedBox(
              width: 246.0,
              child: Text(
                'From the comfort of your home',
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
              width: 314.0,
              child: Text(
                'ನಿಮ್ಮ ವಿಶ್ವಾಸಾರ್ಹ ನೆರೆಹೊರೆಯ\n ಅಂಗಡಿಗಳಿಂದ ಬೇಕಾದ ವಸ್ತುಗಳನ್ನು ಖರೀದಿಸಿ',
                style: TextStyle(
                  fontFamily: 'Baloo Tamma 2',
                  fontSize: 15,
                  color: const Color(0xffe1517d),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        Spacer()
      ],
    );
  }
}

Row buildDialogeWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 20,
      ),
      Image.asset(
        'assets/images/holdingMobile.png',
        height: 166,
        width: 178,
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Shop from your trusted\nneighborhood stores',
                style: TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 15,
                  color: const Color(0xff5f3a9f),
                ),
                textAlign: TextAlign.right,
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    width: 28,
                    color: Color(0xffe1d5f6),
                    height: 2,
                  ),
                ],
              ),
              Text(
                'ನಿಮ್ಮ ಮನೆಯಲ್ಲಿಯೇ\nಆರಾಮವಾಗಿ ಕುಳಿತು',
                style: TextStyle(
                  fontFamily: 'Baloo Tamma 2',
                  fontSize: 15,
                  color: const Color(0xffe1517d),
                  height: 1.3333333333333333,
                ),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
      )
    ],
  );
}
