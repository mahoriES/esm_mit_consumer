import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/rating_indicator.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/secondary_action_button.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/card_header.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/generic_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'widgets/status_specific_content.dart';

class OrdersCard extends StatelessWidget {
  final PlaceOrderResponse orderResponse;
  const OrdersCard(this.orderResponse, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(orderResponse),
      builder: (context, snapshot) {
        final OrderStateData stateData =
            OrderStateData.getStateData(orderResponse.orderStatus, context);

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
                _StatusSpecificContent(
                  orderResponse,
                  rateOrder: snapshot.goToFeedbackView,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ActionButton(
                    text: stateData.actionButtonText,
                    onTap: snapshot.goToOrderDetails,
                    icon: stateData.icon,
                    isFilled: stateData.isActionButtonFilled,
                    textColor: stateData.actionButtonTextColor,
                    buttonColor: stateData.actionButtonColor,
                    showBorder: false,
                    textStyle:
                        CustomTheme.of(context).textStyles.sectionHeading3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: stateData.secondaryAction == SecondaryAction.CANCEL
                          ? CancelOrderButton(snapshot.onCancel)
                          : stateData.secondaryAction == SecondaryAction.REORDER
                              ? ReorderButton(snapshot.onReorder)
                              : PayButton(
                                  onPay: () => snapshot
                                      .payForOrder()
                                      .timeout(const Duration(seconds: 10)),
                                  orderResponse: orderResponse,
                                ),
                    ),
                    Flexible(
                      child: OrderDetailsButton(snapshot.goToOrderDetails),
                    ),
                  ],
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
  Future<void> Function() payForOrder;

  _ViewModel.build({
    this.goToOrderDetails,
    this.ratingValue,
    this.orderStatus,
    this.goToFeedbackView,
    this.orderResponse,
    this.onCancel,
    this.onReorder,
    this.payForOrder,
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
      payForOrder: () async => await dispatchFuture(
        PaymentAction(
          orderId: this.orderResponse.orderId,
          onSuccess: () => dispatch(GetOrderListAPIAction()),
        ),
      ),
    );
  }
}
