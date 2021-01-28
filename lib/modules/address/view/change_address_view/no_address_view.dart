import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoAddressFoundView extends StatelessWidget {
  const NoAddressFoundView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 65),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr("address_picker.add_an_Address"),
              style: CustomTheme.of(context).textStyles.topTileTitle.copyWith(
                    color: CustomTheme.of(context).colors.disabledAreaColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              tr("address_picker.no_address_message"),
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading1Regular
                  .copyWith(
                    color: CustomTheme.of(context).colors.disabledAreaColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
