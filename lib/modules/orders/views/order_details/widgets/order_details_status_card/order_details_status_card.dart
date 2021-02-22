import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/views/widgets/rating_indicator.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/order_progress_indicator.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/payment_tile.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/business_image_with_logo.dart';
import 'package:eSamudaay/reusable_widgets/contact_options_widget.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class OrderDetailsStatusCard extends StatelessWidget {
  const OrderDetailsStatusCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        final OrderStateData stateData = OrderStateData.getStateData(
          orderDetails: snapshot.orderDetails,
          context: context,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Card(
            elevation: 4,
            child: Container(
              child: Column(
                children: [
                  // show business details at top
                  Row(
                    children: [
                      BusinessImageWithLogo(
                        imageUrl: snapshot.orderDetails?.businessImageUrl ?? "",
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.orderDetails?.businessName ?? "",
                              style: CustomTheme.of(context)
                                  .textStyles
                                  .sectionHeading1Regular,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.orderDetails?.totalCountString,
                              style: CustomTheme.of(context).textStyles.body1,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                topRight: Radius.circular(9),
                              ),
                            ),
                            builder: (context) => ContactOptionsWidget(
                              name: snapshot.orderDetails?.businessName ?? "",
                              phoneNumber: snapshot
                                      .orderDetails?.businessContactNumber ??
                                  "",
                            ),
                          );
                        },
                        child: Icon(
                          Icons.call_outlined,
                          color: CustomTheme.of(context).colors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 29),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // show progress indicator
                  OrderProgressIndicator(stateData),
                  const SizedBox(height: 28),

                  // if order is confirmed , show payment info.
                  if (stateData.showPaymentOption) ...{
                    Divider(
                      color: CustomTheme.of(context).colors.dividerColor,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: PaymentStatusTile(
                        orderResponse: snapshot.orderDetails,
                        onPay: () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            enableDrag: false,
                            builder: (context) => PaymentOptionsWidget(
                              showBackOption: true,
                              isCodAvailable: false,
                            ),
                          );
                        },
                      ),
                    ),
                  },

                  // if order is completed , show rating indicator
                  if (stateData.isOrderCompleted) ...{
                    Divider(
                      color: CustomTheme.of(context).colors.dividerColor,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: RatingIndicator(
                        rating: snapshot.orderDetails.rating?.ratingValue ?? 0,
                        onRate: snapshot.orderDetails.isOrderAlreadyRated
                            ? null
                            : snapshot.goToFeedbackView,
                      ),
                    ),
                  },

                  // if order is cancelled, show cancellation reason.
                  if (stateData.isOrderCancelled &&
                      snapshot.hasCancellationNote) ...{
                    ActionButton(
                      text: snapshot.orderDetails.cancellationNote ?? "",
                      onTap: null,
                      isFilled: true,
                      textColor: CustomTheme.of(context).colors.secondaryColor,
                      buttonColor: CustomTheme.of(context)
                          .colors
                          .secondaryColor
                          .withOpacity(0.2),
                      showBorder: false,
                    ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  PlaceOrderResponse orderDetails;
  // Future<void> Function() payForOrder;
  Function(int) goToFeedbackView;

  _ViewModel.build({
    this.orderDetails,
    // this.payForOrder,
    this.goToFeedbackView,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      // payForOrder: () async => await dispatchFuture(
      //   PaymentAction(
      //     orderId: state.ordersState.selectedOrderDetails.orderId,
      //     onSuccess: () => dispatch(
      //       GetOrderDetailsAPIAction(
      //           state.ordersState.selectedOrderDetails.orderId),
      //     ),
      //   ),
      // ),
      goToFeedbackView: (ratingValue) => dispatch(
        NavigateAction.pushNamed(
          RouteNames.ORDER_FEEDBACK_VIEW,
          arguments: ratingValue,
        ),
      ),
    );
  }

  bool get hasCancellationNote =>
      orderDetails.cancellationNote != null &&
      orderDetails.cancellationNote != "";
}
