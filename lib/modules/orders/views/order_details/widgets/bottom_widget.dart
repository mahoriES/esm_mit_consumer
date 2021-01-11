import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/contact_options_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderDetailsBottomWidget extends StatelessWidget {
  final PlaceOrderResponse orderDetails;
  const OrderDetailsBottomWidget(this.orderDetails, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orderDetails == null) return SizedBox.shrink();

    final OrderStateData stateData =
        OrderStateData.getStateData(orderDetails.orderStatus, context);

    return BottomSheet(
      onClosing: () {},
      elevation: 8,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          orderDetails.deliveryType == DeliveryType.StorePickup
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  text: orderDetails.businessName + "\n",
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .sectionHeading2,
                                  children: [
                                    TextSpan(
                                      text: orderDetails
                                          .pickupAddress?.addressString,
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
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      orderDetails.orderStatus == OrderState.PICKED_UP_BY_DA
                          ? InkWell(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9),
                                    topRight: Radius.circular(9),
                                  ),
                                ),
                                builder: (context) => ContactOptionsWidget(
                                  name: "",
                                  phoneNumber: "",
                                ),
                              ),
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
                                      text: orderDetails
                                          .deliveryAdress?.addressString,
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
                  ),
                ),
          StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              return ActionButton(
                text: stateData.actionButtonText,
                onTap: () {
                  if (orderDetails.orderStatus == OrderState.MERCHANT_UPDATED) {
                    showDialog(
                      context: context,
                      builder: (context) => CustomConfirmationDialog(
                        title: tr("screen_order.accept_order") + "?",
                        positiveAction: () {
                          Navigator.pop(context);
                          snapshot.confirmOrder(orderDetails.orderId);
                        },
                        positiveButtonText: tr("common.continue"),
                        negativeButtonText: tr("common.cancel"),
                      ),
                    );
                  }
                },
                icon: stateData.icon,
                isFilled: true,
                textColor: stateData.actionButtonTextColor,
                buttonColor: stateData.actionButtonColor,
                showBorder: false,
                textStyle: CustomTheme.of(context).textStyles.sectionHeading3,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(String) confirmOrder;

  _ViewModel.build({
    this.confirmOrder,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      confirmOrder: (orderId) => dispatch(AcceptOrderAPIAction(orderId)),
    );
  }
}
