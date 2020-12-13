import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/home/actions/home_page_actions.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/repository/cart_datasourse.dart';
import 'package:eSamudaay/reusable_widgets/business_details_popup.dart';
import 'package:eSamudaay/reusable_widgets/business_title_tile.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/link_sharing_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eSamudaay/utilities/extensions.dart';
import 'package:eSamudaay/utilities/size_config.dart';

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
              List<Business> merchants =
                  await CartDataSource.getListOfMerchants();
              if (merchants.isNotEmpty &&
                  merchants.first.businessId !=
                      snapshot.selectedMerchant.businessId) {
                var localMerchant = merchants.first;
                snapshot.updateSelectedMerchant(localMerchant);
              }
            }
            Navigator.pop(context);
          },
          onShowMerchantInfo: () => snapshot.showDetailsPopup(context),
          onContactMerchantPressed: () {
            snapshot.contactMerchantAction(context);
          },
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

  // TODO : not a good idea to keep this in model. Move to view.
  void showDetailsPopup(BuildContext context) {
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
          onContactMerchant: () {
            contactMerchantAction(context);
          },
          merchantPhoneNumber: selectedMerchant.phones.isNotEmpty
              ? selectedMerchant?.phones?.first
              : 'Not Available',
          businessTitle: selectedMerchant.businessName ?? '',
          businessSubtitle: selectedMerchant.description,
          businessPrettyAddress: selectedMerchant.address?.prettyAddress ?? '',
          merchantBusinessImageUrl: selectedMerchant.images.isNotEmpty
              ? selectedMerchant.images.first.photoUrl
              : '',
          isDeliveryAvailable: selectedMerchant.hasDelivery,
        );
      },
    );
  }

  // TODO : not a good idea to keep this in model. Move to view.
  void contactMerchantAction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9), topRight: Radius.circular(9)),
      ),
      builder: (context) => Container(
        child: new Wrap(
          children: <Widget>[
            new ListTile(
              title: new Text(
                'Call ${selectedMerchant.businessName}',
                style: CustomTheme.of(context).textStyles.cardTitle,
              ),
              leading: Icon(
                Icons.call,
                size: 25,
                color: CustomTheme.of(context).colors.positiveColor,
              ),
              onTap: () {
                String phone =
                    selectedMerchant.phones?.first?.formatPhoneNumber;
                if (phone == null) return;
                launch('tel:$phone');
                Navigator.pop(context);
              },
            ),
            new ListTile(
              title: new Text('Whatsapp ${selectedMerchant.businessName}',
                  style: CustomTheme.of(context).textStyles.cardTitle),
              leading: SizedBox(
                  height: 25.toHeight,
                  width: 25.toWidth,
                  child: Image.asset('assets/images/whatsapp.png')),
              onTap: () {
                String phone =
                    selectedMerchant.phones?.first?.formatPhoneNumber;
                if (phone == null) return;
                if (Platform.isIOS) {
                  launch(
                      "whatsapp://wa.me/$phone/?text=${Uri.parse('Message from eSamudaay.')}");
                } else {
                  launch(
                      "whatsapp://send?phone=$phone&text=${Uri.parse('Message from eSamudaay.')}");
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
