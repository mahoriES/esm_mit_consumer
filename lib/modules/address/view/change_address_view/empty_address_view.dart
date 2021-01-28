import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
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
            // Container(
            //   width: 161,
            //   height: 161,
            //   child: CircleAvatar(
            //     backgroundColor:
            //         CustomTheme.of(context).colors.placeHolderColor,
            //     backgroundImage: AssetImage(
            //       ImagePathConstants.deliveryAvailableIcon,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 55),
            Text(
              "No Address Found",
              style:
                  CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                        color: CustomTheme.of(context).colors.textColor,
                      ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
