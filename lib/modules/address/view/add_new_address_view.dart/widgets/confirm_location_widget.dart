import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/address/view/widgets/topTile.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmLocationCard extends StatelessWidget {
  final VoidCallback goToAddressDetails;
  const ConfirmLocationCard({@required this.goToAddressDetails, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.all(20.toWidth),
          color: CustomTheme.of(context).colors.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TopTile(tr("address_picker.select_location")),
              SizedBox(height: 14.toHeight),
              Text(
                tr("address_picker.your_location"),
                style: CustomTheme.of(context).textStyles.body2Faded,
              ),
              SizedBox(height: 8.toHeight),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: CustomTheme.of(context).colors.primaryColor,
                  ),
                  SizedBox(width: 8.toWidth),
                  Expanded(
                    child: Text(
                      snapshot.address?.toString() ?? "",
                      style: CustomTheme.of(context).textStyles.body1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.toHeight),
              ActionButton(
                text: tr("address_picker.confirm_location"),
                onTap: goToAddressDetails,
                isDisabled: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  String address;
  bool isAddressLoading;

  _ViewModel.build({
    this.address,
    this.isAddressLoading,
  }) : super(equals: [
          address,
          isAddressLoading,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      address: state.addressState.addressDetails?.addressLine ?? "",
      isAddressLoading: state.addressState.isAddressLoading,
    );
  }
}
