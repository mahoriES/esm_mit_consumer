import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/models/addess_models.dart';
import 'package:eSamudaay/modules/address/view/change_address_view/change_address_bottom_sheet.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/presentations/loading_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOptionWidget extends StatelessWidget {
  const DeliveryOptionWidget();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        await store.dispatchFuture(GetInitialDeliveryType());
        await store.dispatchFuture(GetInitialSelectedAddress());
      },
      onDidChange: (snapshot) {
        if (snapshot.isAddressLoading) {
          LoadingDialog.show();
        } else {
          LoadingDialog.hide();
        }
      },
      builder: (context, snapshot) => Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _CustomRadioTile(
                    isActive: snapshot.isDeliveryToHomeSelected,
                    onChanged: () => snapshot
                        .updateDeliveryType(DeliveryType.DeliveryToHome),
                    title: "cart.delivery_at_doorstep".tr(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CustomRadioTile(
                    isActive: !snapshot.isDeliveryToHomeSelected,
                    onChanged: () =>
                        snapshot.updateDeliveryType(DeliveryType.StorePickup),
                    title: "cart.pickup_at_store".tr(),
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 26),
            color: CustomTheme.of(context)
                .colors
                .placeHolderColor
                .withOpacity(0.3),
            child: snapshot.isDeliveryToHomeSelected
                ? snapshot.isDeliveryAddressAvailable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_drop_outlined,
                                      size: 17,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .disabledAreaColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        "cart.delivery_to_home".tr(),
                                        style: CustomTheme.of(context)
                                            .textStyles
                                            .cardTitle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  snapshot.deliveryAddress,
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .body1Faded,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  elevation: 4,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      ChangeAddressBottomSheet(),
                                );
                              },
                              child: Text(
                                tr("address_picker.change_address")
                                    .toUpperCase(),
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .body2Secondary,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ActionButton(
                        text: tr("address_picker.add_an_Address"),
                        icon: Icons.add,
                        onTap: snapshot.goToAddNewAddress,
                        isDisabled: false,
                      )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              size: 17,
                              color: CustomTheme.of(context)
                                  .colors
                                  .disabledAreaColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                snapshot.merchantName,
                                style: CustomTheme.of(context)
                                    .textStyles
                                    .cardTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        flex: 1,
                        child: Text(
                          snapshot.storeAddress,
                          style: CustomTheme.of(context).textStyles.body1Faded,
                          textAlign: TextAlign.end,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _CustomRadioTile extends StatelessWidget {
  final bool isActive;
  final VoidCallback onChanged;
  final String title;
  final MainAxisAlignment mainAxisAlignment;
  const _CustomRadioTile({
    @required this.isActive,
    @required this.onChanged,
    @required this.title,
    this.mainAxisAlignment = MainAxisAlignment.start,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: isActive
                    ? CustomTheme.of(context).colors.primaryColor
                    : CustomTheme.of(context).colors.disabledAreaColor,
              ),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? CustomTheme.of(context).colors.primaryColor
                      : CustomTheme.of(context).colors.disabledAreaColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: CustomTheme.of(context).textStyles.cardTitle.copyWith(
                    color: isActive
                        ? CustomTheme.of(context).colors.primaryColor
                        : CustomTheme.of(context).colors.disabledAreaColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  AddressResponse selectedAddress;
  String selectedDeliveryType;
  Business cartMerchant;
  Function(String) updateDeliveryType;
  VoidCallback goToAddNewAddress;
  bool isAddressLoading;

  _ViewModel.build({
    this.selectedAddress,
    this.selectedDeliveryType,
    this.updateDeliveryType,
    this.cartMerchant,
    this.goToAddNewAddress,
    this.isAddressLoading,
  }) : super(equals: [selectedAddress, selectedDeliveryType, isAddressLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedAddress: state.addressState.selectedAddressForDelivery,
      selectedDeliveryType: state.cartState.selectedDeliveryType,
      isAddressLoading: state.addressState.isLoading,
      cartMerchant: state.cartState.cartMerchant,
      goToAddNewAddress: () {
        dispatch(NavigateAction.pushNamed(RouteNames.ADD_NEW_ADDRESS));
      },
      updateDeliveryType: (type) {
        if (type == DeliveryType.DeliveryToHome &&
            !state.cartState.cartMerchant.hasDelivery) {
          Fluttertoast.showToast(
            msg: "cart.delivery_not_available_error".tr(
              args: [state.cartState.cartMerchant?.businessName],
            ),
          );
        } else {
          dispatch(UpdateDeliveryType(type));
        }
      },
    );
  }

  bool get isDeliveryToHomeSelected =>
      selectedDeliveryType == DeliveryType.DeliveryToHome;

  bool get isDeliveryAddressAvailable => selectedAddress != null;

  String get merchantName => cartMerchant?.businessName ?? "";

  String get deliveryAddress =>
      (_deliveryHouse == null ? "" : "$_deliveryHouse, ") +
      (_deliveryAddress ?? "") +
      (_deliveryLandmark == null
          ? ""
          : ("\n" + "${tr('cart.landmark')} : $_deliveryLandmark"));

  String get _deliveryHouse => selectedAddress?.geoAddr?.house;
  String get _deliveryLandmark => selectedAddress?.geoAddr?.landmark;
  String get _deliveryAddress => selectedAddress?.prettyAddress;

  String get storeAddress =>
      (_storeHouse == null ? "" : "$_storeHouse, ") +
      (_storeAddress ?? "") +
      (_storeLandmark == null
          ? ""
          : ("\n" + "${tr('cart.landmark')} : $_storeLandmark"));

  String get _storeHouse => cartMerchant.address?.geoAddr?.house;
  String get _storeLandmark => cartMerchant.address?.geoAddr?.landmark;
  String get _storeAddress => cartMerchant.address?.prettyAddress;
}
