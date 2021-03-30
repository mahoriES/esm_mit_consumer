import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/charge_details_response.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_positioned_dialog.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/modules/cart/views/widgets/charges_list_widget/widgets/widgets.dart';

class CartChargesListWidget extends StatelessWidget {
  CartChargesListWidget({Key key}) : super(key: key);

  final GlobalKey deliveryChargeKey = new GlobalKey();
  final GlobalKey merchantChargeKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) => Column(
        children: [
          ChargesListTile(
            chargeName: tr("cart.item_total"),
            price: snapshot.getCartTotal,
          ),
          const SizedBox(height: 2),
          Container(
            key: deliveryChargeKey,
            margin: const EdgeInsets.symmetric(vertical: 14),
            child: ChargesListTile(
              chargeName: tr("cart.delivery_partner_fee"),
              price: snapshot.deliveryCharge,
              style: CustomTheme.of(context)
                  .textStyles
                  .body1FadedWithDottedUnderline,
              onTap: () => CustomPositionedDialog.show(
                key: deliveryChargeKey,
                content: DeliveryChargeInfoCard(),
                context: context,
                margin: Size(0, 45),
              ),
            ),
          ),
          Container(
            key: merchantChargeKey,
            child: ChargesListTile(
              chargeName: tr("cart.merchant_charges"),
              price: snapshot.merchantCharge,
              style: CustomTheme.of(context)
                  .textStyles
                  .body1FadedWithDottedUnderline,
              onTap: () => CustomPositionedDialog.show(
                key: merchantChargeKey,
                context: context,
                content: MerchantChargesInfoCard(
                  packingCharge: snapshot.packingCharge,
                  serviceCharge: snapshot.serviceCharge,
                  extraCharge: snapshot.extraCharge,
                ),
                margin: Size(0, 80),
              ),
            ),
          ),
          Divider(
            color: CustomTheme.of(context).colors.dividerColor,
            thickness: 1,
            height: 40,
          ),
          ChargesListTile(
            chargeName: tr("cart.grand_total"),
            price: snapshot.grandTotal,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  List<Product> productsList;
  CartCharges charges;

  _ViewModel.build({
    this.productsList,
    this.charges,
  }) : super(equals: [productsList, charges]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      productsList: state.cartState.localCartItems ?? [],
      charges: state.cartState.charges,
    );
  }

  double get getCartTotal {
    if (productsList.isEmpty) return 0;
    return productsList.fold(0, (previous, current) {
          double price = current.selectedSkuPrice * current.count;
          return (previous + price);
        }) ??
        0;
  }

  double get deliveryCharge {
    if (charges?.deliveryCharge == null) return 0;
    if (charges.deliveryCharge.isPercentageType) {
      return (getCartTotal * (charges.deliveryCharge.chargeValue)) / 100;
    }
    return charges?.deliveryCharge?.amount?.toDouble() ?? 0;
  }

  double get packingCharge {
    if (charges?.packingCharge == null) return 0;
    if (charges.packingCharge.isPercentageType) {
      return (getCartTotal * (charges.packingCharge.chargeValue)) / 100;
    }
    return charges?.packingCharge?.amount?.toDouble() ?? 0;
  }

  double get serviceCharge {
    if (charges?.serviceCharge == null) return 0;
    if (charges.serviceCharge.isPercentageType) {
      return (getCartTotal * (charges.serviceCharge.chargeValue)) / 100;
    }
    return charges?.serviceCharge?.amount?.toDouble() ?? 0;
  }

  double get extraCharge {
    if (charges?.extraCharge == null) return 0;
    if (charges.extraCharge.isPercentageType) {
      return (getCartTotal * (charges.extraCharge.chargeValue)) / 100;
    }
    return charges?.extraCharge?.amount?.toDouble() ?? 0;
  }

  double get merchantCharge => packingCharge + serviceCharge + extraCharge;

  double get grandTotal => getCartTotal + deliveryCharge + merchantCharge;
}
