import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/address/view/change_address_view/widgets/multiple_address_widget.dart';
import 'package:eSamudaay/modules/address/view/widgets/topTile.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeAddressBottomSheet extends StatelessWidget {
  const ChangeAddressBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Container(
          height: SizeConfig.screenHeight / 2,
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
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
              Expanded(
                child: MultipleAddressWidget(
                  onTapOnAddress: (address) {
                    snapshot.updateSelectedAddress(address);
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.toWidth),
                child: ActionButton(
                  text: tr("address_picker.add_an_Address"),
                  icon: Icons.add,
                  onTap: snapshot.goToAddNewAddress,
                  isDisabled: false,
                ),
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

  Function goToAddNewAddress;
  Function(AddressResponse) updateSelectedAddress;

  _ViewModel.build({this.goToAddNewAddress, this.updateSelectedAddress})
      : super(equals: []);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      goToAddNewAddress: () async {
        dispatch(UpdateIsRegisterFlow(false));
        await dispatchFuture(
            NavigateAction.pushNamed(RouteNames.ADD_NEW_ADDRESS));
      },
      updateSelectedAddress: (address) =>
          dispatch(UpdateSelectedAddressForDelivery(address)),
    );
  }
}
