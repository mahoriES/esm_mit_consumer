import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/size_cpnfig.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourthPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Spacer(),
        Image.asset(
          'assets/images/allHands.png',
          height: SizeConfig.safeBlockVertical * 50,
          width: SizeConfig.safeBlockHorizontal * 70,
          fit: BoxFit.cover,
        ),
        Spacer(),
        ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              width: 314.0,
              child: Text(
                'Connect with your community\nand discover new things',
                style: TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 20,
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
              width: 258.0,
              child: Text(
                'ಸ್ಥಳೀಯ ಸಮುದಾಯದೊಂದಿಗೆ ಸೇರಿ\nಮತ್ತು ಹೊಸ ವಿಷಯಗಳನ್ನು ಅನ್ವೇಷಿಸಿ',
                style: TextStyle(
                  fontFamily: 'Baloo Tamma 2',
                  fontSize: 15,
                  color: const Color(0xffe1517d),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                await UserManager.saveSkipStatus(status: true);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('first_time', false);
                store.dispatch(
                    NavigateAction.pushNamedAndRemoveAll('/language'));
              },
              child: Container(
                width: 234.0,
                height: 61.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xff5f3a9f),
                ),
                child: Center(
                  child: Text(
                    'Join the eSamudaay',
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 18,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
