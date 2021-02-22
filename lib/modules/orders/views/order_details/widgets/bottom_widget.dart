import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/widgets/order_action_button.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/generic_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailsBottomWidget extends StatelessWidget {
  const OrderDetailsBottomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (snapshot.orderDetails.deliveryType ==
                        DeliveryType.StorePickup) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.store_sharp,
                            color: CustomTheme.of(context).colors.warningColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tr("screen_order.store_pickup"),
                            style: CustomTheme.of(context)
                                .textStyles
                                .cardTitle
                                .copyWith(
                                  color: CustomTheme.of(context)
                                      .colors
                                      .warningColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: snapshot.showNavigationToStore,
                              child: Icon(
                                Icons.pin_drop,
                                color:
                                    CustomTheme.of(context).colors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      snapshot.orderDetails.businessName + "\n",
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .sectionHeading2,
                                  children: [
                                    TextSpan(
                                      text: snapshot.orderDetails.pickupAddress
                                          ?.addressString,
                                      style: CustomTheme.of(context)
                                          .textStyles
                                          .body1Faded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      snapshot.orderDetails.orderStatus ==
                              OrderState.PICKED_UP_BY_DA
                          ? InkWell(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg:
                                      "Delivery Person Contact Info is not available",
                                );
                                // showModalBottomSheet(
                                //   context: context,
                                //   elevation: 3.0,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.only(
                                //       topLeft: Radius.circular(9),
                                //       topRight: Radius.circular(9),
                                //     ),
                                //   ),
                                //   builder: (context) => ContactOptionsWidget(
                                //     name: "",
                                //     phoneNumber: "",
                                //   ),
                                // );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: CustomTheme.of(context)
                                        .colors
                                        .primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    tr("screen_order.contact_delivery_person")
                                        .toUpperCase(),
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .body2BoldPrimary,
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.directions_bike,
                                  color: CustomTheme.of(context)
                                      .colors
                                      .positiveColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tr("screen_order.home_delivery"),
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .cardTitle
                                      .copyWith(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .positiveColor,
                                      ),
                                ),
                              ],
                            ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: CustomTheme.of(context)
                                  .colors
                                  .disabledAreaColor,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  text: tr("screen_order.home") + "\n",
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .sectionHeading2,
                                  children: [
                                    TextSpan(
                                      text: snapshot.orderDetails.deliveryAdress
                                          ?.addressString,
                                      style: CustomTheme.of(context)
                                          .textStyles
                                          .body1Faded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              OrderActionButton(
                orderResponse: snapshot.orderDetails,
                isOrderDetailsView: true,
                goToOrderDetails: null,
                confirmOrder: () =>
                    snapshot.confirmOrder(snapshot.orderDetails.orderId),
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

  PlaceOrderResponse orderDetails;
  Function(String) confirmOrder;

  _ViewModel.build({
    this.orderDetails,
    this.confirmOrder,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      confirmOrder: (orderId) => dispatch(AcceptOrderAPIAction(orderId)),
    );
  }

  showNavigationToStore() {
    GenericMethods.openMap(
      orderDetails?.pickupAddress?.locationPoint?.lat ?? 0,
      orderDetails?.pickupAddress?.locationPoint?.lon ?? 0,
    );
  }
}
