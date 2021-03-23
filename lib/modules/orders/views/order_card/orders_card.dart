import 'package:async_redux/async_redux.dart';

import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/order_card_secondary_actions_row.dart';
import 'package:eSamudaay/modules/orders/views/widgets/order_action_button.dart';
import 'package:eSamudaay/modules/orders/views/widgets/rating_indicator.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/modules/orders/views/widgets/order_card_header.dart';
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
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Card(
          key: new ObjectKey(orderResponse.orderId),
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
                  rateOrder: (rating) =>
                      snapshot.goToFeedbackView(rating, orderResponse),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: OrderActionButton(
                    goToOrderDetails: () =>
                        snapshot.goToOrderDetails(orderResponse),
                    confirmOrder: () =>
                        snapshot.confirmOrder(orderResponse.orderId),
                    orderResponse: orderResponse,
                    isOrderDetailsView: false,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: OrderCardSecondaryButtonsRow(
                    orderResponse: orderResponse,
                    onCancel: (note) => snapshot.onCancel(note, orderResponse),
                    onReorder: () => snapshot.onReorder(orderResponse),
                    goToOrderDetails: () =>
                        snapshot.goToOrderDetails(orderResponse),
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
  _ViewModel();

  Function(PlaceOrderResponse) goToOrderDetails;
  Function(int, PlaceOrderResponse) goToFeedbackView;
  Function(String, PlaceOrderResponse) onCancel;
  Function(PlaceOrderResponse) onReorder;
  Function(String) confirmOrder;

  _ViewModel.build({
    this.goToOrderDetails,
    this.goToFeedbackView,
    this.onCancel,
    this.onReorder,
    this.confirmOrder,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      goToOrderDetails: (orderResponse) async {
        await dispatchFuture(ResetSelectedOrder(orderResponse));
        dispatch(NavigateAction.pushNamed(RouteNames.ORDER_DETAILS));
      },
      goToFeedbackView: (ratingValue, orderResponse) async {
        await dispatchFuture(ResetSelectedOrder(orderResponse));
        dispatch(NavigateAction.pushNamed(
          RouteNames.ORDER_FEEDBACK_VIEW,
          arguments: ratingValue,
        ));
      },
      onCancel: (String cancellationNote, orderResponse) => dispatch(
        CancelOrderAPIAction(
          orderId: orderResponse.orderId,
          cancellationNote: cancellationNote,
        ),
      ),
      onReorder: (orderResponse) => dispatch(
        ReorderAction(
          orderResponse: orderResponse,
          shouldFetchOrderDetails: true,
        ),
      ),
      confirmOrder: (orderId) => dispatch(AcceptOrderAPIAction(orderId)),
    );
  }
}
