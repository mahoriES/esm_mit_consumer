import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class TopTile extends StatelessWidget {
  final String title;
  const TopTile(
    this.title, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTheme.of(context).textStyles.topTileTitle,
        ),
        TextButton(
          child: Icon(
            Icons.clear,
            color: CustomTheme.of(context).colors.primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
