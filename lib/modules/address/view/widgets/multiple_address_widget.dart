import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MultipleAddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (snapshot.isLoading) {
            LoadingDialog.show();
          } else {
            LoadingDialog.hide();
          }
        });

        return Container(
          padding: EdgeInsets.all(24.toWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(
                  tr("address_picker.saved_addresses"),
                  style: CustomTheme.of(context).textStyles.body1,
                ),
                SizedBox(height: 10),

                // addresses list //
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.savedAddresses?.length ?? 0,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.savedAddresses[index].addressName,
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .cardTitle,
                              ),
                              Text(
                                snapshot.savedAddresses[index].prettyAddress,
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .body1Faded,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        if (snapshot.savedAddresses.length > 1) ...[
                          Flexible(
                            flex: 1,
                            child: TextButton(
                              child: Text(
                                tr("address_picker.delete_address"),
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .body2Secondary,
                              ),
                              onPressed: () => snapshot.deleteAddress(
                                  snapshot.savedAddresses[index].addressId),
                            ),
                          ),
                        ]
                      ],
                    );
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  bool isLoading;
  List<AddressResponse> savedAddresses;
  Function(String) deleteAddress;

  _ViewModel.build({
    this.savedAddresses,
    this.deleteAddress,
    this.isLoading,
  }) : super(equals: [savedAddresses, isLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      savedAddresses: state.addressState.savedAddressList,
      isLoading: state.addressState.isLoading,
      deleteAddress: (String addressId) =>
          dispatch(DeleteAddressAction(addressId)),
    );
  }
}
