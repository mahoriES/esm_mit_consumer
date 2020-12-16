import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class DetailsTile extends StatelessWidget {
  final String data;
  final TextStyle style;
  const DetailsTile({
    @required this.data,
    @required this.style,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 8.toHeight,
        horizontal: 4.toWidth,
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: CustomTheme.of(context).colors.textColor,
        )),
      ),
      child: Text(
        data ?? "",
        style: style,
      ),
    );
  }
}
