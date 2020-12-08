import 'dart:ui';

import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/address/view/change_address_view/widgets/multiple_address_widget.dart';
import 'package:eSamudaay/modules/address/view/widgets/topTile.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeAddressBottomSheet extends StatelessWidget {
  const ChangeAddressBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 24.toHeight),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.toWidth),
            child: TopTile(tr("address_picker.select_an_address")),
          ),
          Expanded(child: MultipleAddressWidget()),
          Padding(
            padding: EdgeInsets.all(24.toWidth),
            child: ActionButton(
              text: tr("address_picker.add_an_Address"),
              icon: Icons.add,
              onTap: () {}, // snapshot.goToAddNewAddress,
              isDisabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
