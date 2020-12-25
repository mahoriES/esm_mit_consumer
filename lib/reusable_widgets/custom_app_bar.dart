import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final String subTitle;
  final List<Widget> actions;
  const CustomAppBar({
    @required this.title,
    this.subTitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        iconSize: 36.toFont,
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: CustomTheme.of(context).textStyles.topTileTitle,
            maxLines: 1,
          ),
          if (subTitle != null && subTitle != "") ...[
            Text(
              subTitle,
              style: CustomTheme.of(context).textStyles.body1,
              maxLines: 1,
            ),
          ]
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, AppBar().preferredSize.height);
}
