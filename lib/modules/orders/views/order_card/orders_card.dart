import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/rating_component.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/contact_options_widget.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/generic_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'widgets/cancel_order_prompt.dart';

part 'widgets/card_header.dart';
part 'widgets/status_specific_content.dart';
part 'widgets/secondary_action_button.dart';

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
                _CardHeader(orderResponse),
                const SizedBox(height: 12),
                Divider(
                  color: CustomTheme.of(context).colors.dividerColor,
                  thickness: 1.5,
                ),
                _StatusSpecificContent(
                  orderResponse,
                  rateOrder: snapshot.rateOrder,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ActionButton(
                    text: stateData.actionButtonText,
                    onTap: () => snapshot.goToOrderDetails(orderResponse),
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
                _SecondaryActionsRow(
                  stateData: stateData,
                  onCancel: snapshot.onCancel,
                  onReOrder: snapshot.onReorder,
                  goToOrderDetails: () =>
                      snapshot.goToOrderDetails(orderResponse),
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

  Function(PlaceOrderResponse) goToOrderDetails;
  int ratingValue;
  String orderStatus;
  Function(int) rateOrder;
  Function(String) onCancel;
  VoidCallback onReorder;

  _ViewModel.build({
    this.goToOrderDetails,
    this.ratingValue,
    this.orderStatus,
    this.rateOrder,
    this.orderResponse,
    this.onCancel,
    this.onReorder,
  }) : super(equals: [ratingValue, orderStatus]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderResponse: this.orderResponse,
      ratingValue: this.orderResponse.rating.ratingValue,
      orderStatus: this.orderResponse.orderStatus,
      goToOrderDetails: (order) async {
        await dispatchFuture(SetSelectedOrderForDetails(order));
        dispatch(NavigateAction.pushNamed(RouteNames.ORDER_DETAILS));
      },
      rateOrder: (ratingValue) => dispatch(
        AddRatingAPIAction(
          request: AddReviewRequest(ratingValue: ratingValue),
          orderId: this.orderResponse.orderId,
        ),
      ),
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
    );
  }
}
