import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/multiple_address_widget.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeAddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr("address_picker.change_address"),
              style: CustomTheme.of(context).textStyles.topTileTitle,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: MultipleAddressWidget(),
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
              SizedBox(height: 20.toHeight),
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

  _ViewModel.build({this.goToAddNewAddress}) : super(equals: []);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      goToAddNewAddress: () {
        dispatch(NavigateAction.pushNamed(RouteNames.ADD_NEW_ADDRESS));
      },
    );
  }
}
