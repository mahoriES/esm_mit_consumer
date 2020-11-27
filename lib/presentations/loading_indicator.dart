import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/indicator.gif',
        height: 75.toHeight,
        width: 75.toWidth,
      ),
    );
  }
}
