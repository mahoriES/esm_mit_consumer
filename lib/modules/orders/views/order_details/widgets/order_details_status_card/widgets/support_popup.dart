import 'dart:math';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPopup extends StatelessWidget {
  const SupportPopup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: min(320, SizeConfig.screenWidth - 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("support.need_help"),
                  style: CustomTheme.of(context).textStyles.cardTitle,
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => launch('tel:7709514625'),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePathConstants.callIcon,
                        width: 20,
                      ),
                      SizedBox(width: 15),
                      Text(
                        tr("support.call_cp") + "\nRajesh Rao +91 7709514625",
                        style: CustomTheme.of(context).textStyles.body2Faded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              child: Icon(
                Icons.clear,
                size: 16,
                color: CustomTheme.of(context).colors.disabledAreaColor,
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
