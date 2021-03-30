import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/reusable_widgets/contact_options_widget.dart';
import 'package:eSamudaay/utilities/link_sharing_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BusinessHeaderView extends StatelessWidget {
  final bool showDescription;
  final bool resetMerchantOnBack;
  const BusinessHeaderView({
    this.showDescription = true,
    @required this.resetMerchantOnBack,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void contactMerchantAction(String businessName, String contactNumber) {
      if (contactNumber == null || contactNumber.isEmpty) {
        Fluttertoast.showToast(msg: tr("common.contact_details_error"));
        return;
      }
      showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9), topRight: Radius.circular(9)),
        ),
        builder: (context) => ContactOptionsWidget(
          name: businessName,
          phoneNumber: contactNumber,
        ),
      );
    }

    void showDetailsPopup(Business selectedMerchant) {
      showDialog(
        context: context,
        builder: (context) {
          return BusinessDetailsPopup(
            businessId: selectedMerchant.businessId,
            locationPoint: selectedMerchant.address?.locationPoint ?? null,
            onShareMerchant: () async {
              LoadingDialog.show();
              await LinkSharingService().shareBusinessLink(
                businessId: selectedMerchant.businessId,
                storeName: selectedMerchant.businessName,
              );
              LoadingDialog.hide();
            },
            onContactMerchant: () => contactMerchantAction(
              selectedMerchant?.businessName ?? "",
              selectedMerchant?.contactNumber ?? "",
            ),
            merchantPhoneNumber: (selectedMerchant.phones?.isNotEmpty ?? false)
                ? selectedMerchant?.contactNumber
                : 'Not Available',
            businessTitle: selectedMerchant.businessName ?? '',
            businessSubtitle: selectedMerchant.description,
            businessPrettyAddress:
                selectedMerchant.address?.prettyAddress ?? '',
            merchantBusinessImageUrl: selectedMerchant.images.isNotEmpty
                ? selectedMerchant.images.first.photoUrl
                : '',
            isDeliveryAvailable: selectedMerchant.hasDelivery,
          );
        },
      );
    }

    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 13, 6, 0),
        child: BusinessTitleTile(
          businessId: snapshot.selectedMerchant.businessId,
          businessName: snapshot.selectedMerchant.businessName ?? '',
          businessSubtitle: showDescription
              ? (snapshot.selectedMerchant.description ?? '')
              : null,
          isDeliveryAvailable: snapshot.selectedMerchant.hasDelivery,
          isOpen: snapshot.selectedMerchant.isOpen ?? true,
          businessImageUrl: snapshot.selectedMerchant.images.isNotEmpty
              ? snapshot.selectedMerchant.images.first.photoUrl
              : "",
          onBackPressed: () async {
            if (resetMerchantOnBack) {
              // TODO : this logic to update selected merchant from cart data doesn't seem right.
              // Can't update now as it may cause errors in store details.
              Business merchants = await CartDataSource.getCartMerchant();
              if (merchants != null &&
                  merchants.businessId !=
                      snapshot.selectedMerchant.businessId) {
                var localMerchant = merchants;
                snapshot.updateSelectedMerchant(localMerchant);
              }
            }
            Navigator.pop(context);
          },
          onShowMerchantInfo: () => showDetailsPopup(snapshot.selectedMerchant),
          onContactMerchantPressed: () => contactMerchantAction(
            snapshot.selectedMerchant?.businessName ?? "",
            snapshot.selectedMerchant?.contactNumber ?? "",
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(Business) updateSelectedMerchant;
  Business selectedMerchant;

  _ViewModel();

  _ViewModel.build({
    this.selectedMerchant,
    this.updateSelectedMerchant,
  }) : super(equals: [selectedMerchant]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedMerchant: state.productState.selectedMerchant,
      updateSelectedMerchant: (Business merchant) {
        dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
      },
    );
  }
}
