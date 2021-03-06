import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/actions/address_actions.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/address/view/change_address_view/no_address_view.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MultipleAddressWidget extends StatelessWidget {
  // we need this onTap method when opened through cart
  // but not when opened through profile.
  // so keeping it variable via making onTapOnAddress an optional field.
  final Function(AddressResponse) onTapOnAddress;
  MultipleAddressWidget({this.onTapOnAddress});
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onDidChange: (snapshot) {
        if (snapshot.isLoading) {
          LoadingDialog.show();
        } else {
          LoadingDialog.hide();
        }
      },
      builder: (context, snapshot) {
        if (snapshot.savedAddresses.isEmpty) {
          return NoAddressFoundView();
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.toWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 6.toHeight),

                Text(
                  tr("address_picker.saved_addresses"),
                  style: CustomTheme.of(context).textStyles.body1,
                ),

                SizedBox(height: 12.toHeight),

                // addresses list //
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.savedAddresses?.length ?? 0,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () => onTapOnAddress == null
                            ? null
                            : onTapOnAddress(snapshot.savedAddresses[index]),
                        splashColor: onTapOnAddress == null
                            ? Colors.transparent
                            : Theme.of(context).splashColor,
                        highlightColor: onTapOnAddress == null
                            ? Colors.transparent
                            : Theme.of(context).highlightColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.savedAddresses[index]
                                            ?.addressName ??
                                        tr("address_picker.Other"),
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .cardTitle,
                                  ),
                                  Text(
                                    snapshot.savedAddresses[index]
                                            ?.addressWithDetails ??
                                        "",
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
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          tr("address_picker.delete_address")
                                              .toUpperCase(),
                                          style: CustomTheme.of(context)
                                              .textStyles
                                              .body2Secondary,
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomConfirmationDialog(
                                            title:
                                                tr("address_picker.delete_address") +
                                                    "?",
                                            message: tr(
                                              "address_picker.confirm_delete_message",
                                              namedArgs: {
                                                'addressName': snapshot
                                                    .savedAddresses[index]
                                                    .addressName,
                                              },
                                            ),
                                            actionButtonColor:
                                                CustomTheme.of(context)
                                                    .colors
                                                    .warningColor,
                                            positiveAction: () {
                                              Navigator.pop(context);
                                              snapshot.deleteAddress(snapshot
                                                  .savedAddresses[index]
                                                  .addressId);
                                            },
                                            positiveButtonText:
                                                tr("address_picker.delete"),
                                            negativeButtonText:
                                                tr("screen_order.Cancel"),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
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
      savedAddresses: state.addressState?.savedAddressList ?? [],
      isLoading: state.addressState.isLoading,
      deleteAddress: (String addressId) =>
          dispatch(DeleteAddressAction(addressId)),
    );
  }
}
