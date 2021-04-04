import 'dart:math';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/cancel_button_tile.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/support_popup.dart';
import 'package:eSamudaay/modules/orders/views/widgets/rating_indicator.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/order_progress_indicator.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/widgets/payment_tile.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/business_image_with_logo.dart';
import 'package:eSamudaay/reusable_widgets/custom_positioned_dialog.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderDetailsStatusCard extends StatelessWidget {
  OrderDetailsStatusCard({Key key}) : super(key: key);

  final GlobalKey supportPopupKey = new GlobalKey();

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
                      Container(
                        key: supportPopupKey,
                        child: InkWell(
                          onTap: () => CustomPositionedDialog.show(
                            key: supportPopupKey,
                            content: SupportPopup(),
                            context: context,
                            margin: Size(
                              min(320, SizeConfig.screenWidth - 90),
                              30,
                            ),
                          ),
                          child: Image.asset(
                            ImagePathConstants.supportIcon,
                            fit: BoxFit.contain,
                            width: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 29),
                    ],
                  ),

                  // show progress indicator if order is created
                  if (snapshot.orderDetails.orderStatus !=
                      OrderState.CUSTOMER_PENDING) ...{
                    const SizedBox(height: 30),
                    OrderProgressIndicator(stateData),
                    const SizedBox(height: 28),
                  } else ...{
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Text(
                        tr("screen_order.pending_payment_message"),
                        style: CustomTheme.of(context)
                            .textStyles
                            .cardTitleSecondary,
                      ),
                    ),
                  },

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
                        onPay: () => showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          enableDrag: false,
                          builder: (context) => PaymentOptionsWidget(
                            showBackOption: true,
                            orderDetails: snapshot.orderDetails,
                            onPaymentSuccess: () {},
                          ),
                        ),
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

                  if (stateData.secondaryAction == SecondaryAction.CANCEL) ...{
                    OrderDetailsCancelButtonTile(
                      onCancel: snapshot.onCancel,
                      orderResponse: snapshot.orderDetails,
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
  Function(int) goToFeedbackView;
  Function(String) onCancel;

  _ViewModel.build({
    this.orderDetails,
    this.goToFeedbackView,
    this.onCancel,
  });

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      orderDetails: state.ordersState.selectedOrderDetails,
      onCancel: (String cancellationNote) {
        dispatch(
          CancelOrderAPIAction(
            orderId: state.ordersState.selectedOrderDetails.orderId,
            cancellationNote: cancellationNote,
          ),
        );
      },
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
