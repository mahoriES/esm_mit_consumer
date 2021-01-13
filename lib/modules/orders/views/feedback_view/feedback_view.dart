import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/feedback_view/widgets/order_rating_widget.dart';
import 'package:eSamudaay/modules/orders/views/feedback_view/widgets/product_rating_widget.dart';
import 'package:eSamudaay/modules/orders/views/order_card/widgets/card_header.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/error_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackView extends StatelessWidget {
  final int ratingValue;
  FeedbackView(this.ratingValue, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatch(ResetReviewRequest(ratingValue ?? 0));
        store.dispatch(GetOrderDetailsAPIAction(
            store.state.ordersState.selectedOrderForDetails?.orderId));
      },
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Rate Your Order",
          ),
          bottomSheet: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58, vertical: 20),
              child: ActionButton(
                text: "Submit Your Feedback",
                onTap: snapshot.rateOrder,
                isFilled: true,
                showBorder: false,
                buttonColor: CustomTheme.of(context).colors.positiveColor,
                textColor: CustomTheme.of(context).colors.backgroundColor,
              ),
            ),
          ),
          body: snapshot.isLoading
              ? LoadingIndicator()
              : snapshot.hasError
                  ? Center(child: GenericErrorView(snapshot.getOrderDetails))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  OrderCardHeader(snapshot.orderDetails),
                                  const SizedBox(height: 36),
                                  OrderRatingWidget(ratingValue),
                                ],
                              ),
                            ),
                          ),
                          ProductRatingWidget(snapshot.orderDetails),
                          const SizedBox(height: 120),
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

  bool isLoading;
  bool hasError;
  PlaceOrderResponse orderDetails;
  VoidCallback rateOrder;
  VoidCallback getOrderDetails;

  _ViewModel.build({
    this.isLoading,
    this.hasError,
    this.orderDetails,
    this.rateOrder,
    this.getOrderDetails,
  }) : super(equals: [isLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      isLoading:
          state.ordersState.isLoadingOrderDetails == LoadingStatusApp.loading ||
              state.ordersState.isLoadingOrdersList == LoadingStatusApp.loading,
      hasError:
          state.ordersState.isLoadingOrderDetails == LoadingStatusApp.error,
      orderDetails: state.ordersState.selectedOrderDetailsResponse,
      getOrderDetails: () => dispatch(
        GetOrderDetailsAPIAction(
            state.ordersState.selectedOrderForDetails?.orderId),
      ),
      rateOrder: () {
        if (state.ordersState.reviewRequest.ratingValue == null ||
            state.ordersState.reviewRequest.ratingValue <= 0) {
          Fluttertoast.showToast(msg: "Please rate the order");
        } else {
          dispatch(NavigateAction.pop());
          dispatch(
            AddRatingAPIAction(
              request: state.ordersState.reviewRequest,
              orderId: state.ordersState.selectedOrderDetailsResponse.orderId,
            ),
          );
        }
      },
    );
  }
}
