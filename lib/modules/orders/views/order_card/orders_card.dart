import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/orders/views/widgets/order_action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/widgets/rating_indicator.dart';
import 'package:eSamudaay/modules/orders/views/widgets/secondary_action_button.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/modules/orders/views/widgets/order_card_header.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/generic_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
part 'widgets/order_card_message.dart';

class OrdersCard extends StatelessWidget {
  final PlaceOrderResponse orderResponse;
  const OrdersCard(this.orderResponse, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "orders acrd => ${orderResponse.orderCreationTimeDiffrenceInSeconds}");
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(orderResponse),
      builder: (context, snapshot) {
        final OrderStateData stateData = OrderStateData.getStateData(
          orderDetails: orderResponse,
          context: context,
        );

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OrderCardHeader(orderResponse),
                const SizedBox(height: 12),
                Divider(
                  color: CustomTheme.of(context).colors.dividerColor,
                  thickness: 1.5,
                ),
                _OrderCardMessage(
                  orderResponse,
                  rateOrder: snapshot.goToFeedbackView,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: OrderActionButton(
                    goToOrderDetails: snapshot.goToOrderDetails,
                    confirmOrder: () =>
                        snapshot.confirmOrder(orderResponse.orderId),
                    orderResponse: orderResponse,
                    isOrderDetailsView: false,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (stateData.secondaryAction !=
                          SecondaryAction.NONE) ...[
                        Flexible(
                          child: stateData.secondaryAction ==
                                  SecondaryAction.CANCEL
                              ? CancelOrderButton(
                                  onCancel: snapshot.onCancel,
                                  orderCreationTimeDiffrenceInSeconds:
                                      orderResponse
                                          .orderCreationTimeDiffrenceInSeconds,
                                )
                              : stateData.secondaryAction ==
                                      SecondaryAction.REORDER
                                  ? ReorderButton(snapshot.onReorder)
                                  : stateData.secondaryAction ==
                                          SecondaryAction.PAY
                                      ? PayButton(
                                          onPay: () => showModalBottomSheet(
                                            context: context,
                                            isDismissible: false,
                                            enableDrag: false,
                                            builder: (context) =>
                                                PaymentOptionsWidget(
                                              showBackOption: true,
                                              orderDetails: orderResponse,
                                              onPaymentSuccess: () {},
                                            ),
                                          ),
                                          orderResponse: orderResponse,
                                        )
                                      : SizedBox.shrink(),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: OrderDetailsButton(
                          snapshot.goToOrderDetails,
                          // If no Secondary Action is available , then order details button should be aligned in center.
                          isCenterAligned:
                              stateData.secondaryAction == SecondaryAction.NONE,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  final PlaceOrderResponse orderResponse;

  _ViewModel(this.orderResponse);

  VoidCallback goToOrderDetails;
  int ratingValue;
  String orderStatus;
  Function(int) goToFeedbackView;
  Function(String) onCancel;
  VoidCallback onReorder;
  Function(String) confirmOrder;

  _ViewModel.build({
    this.goToOrderDetails,
    this.ratingValue,
    this.orderStatus,
    this.goToFeedbackView,
    this.orderResponse,
    this.onCancel,
    this.onReorder,
    this.confirmOrder,
  }) : super(equals: [ratingValue, orderStatus]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderResponse: this.orderResponse,
      ratingValue: this.orderResponse.rating.ratingValue,
      orderStatus: this.orderResponse.orderStatus,
      goToOrderDetails: () async {
        await dispatchFuture(ResetSelectedOrder(this.orderResponse));
        dispatch(NavigateAction.pushNamed(RouteNames.ORDER_DETAILS));
      },
      goToFeedbackView: (ratingValue) async {
        await dispatchFuture(ResetSelectedOrder(this.orderResponse));
        dispatch(NavigateAction.pushNamed(
          RouteNames.ORDER_FEEDBACK_VIEW,
          arguments: ratingValue,
        ));
      },
      onCancel: (String cancellationNote) => dispatch(
        CancelOrderAPIAction(
          orderId: this.orderResponse.orderId,
          cancellationNote: cancellationNote,
        ),
      ),
      onReorder: () => dispatch(
        ReorderAction(
          orderResponse: this.orderResponse,
          shouldFetchOrderDetails: true,
        ),
      ),
      confirmOrder: (orderId) => dispatch(AcceptOrderAPIAction(orderId)),
    );
  }
}
