import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/feedback_view/widgets/order_rating_widget.dart';
import 'package:eSamudaay/modules/orders/views/feedback_view/widgets/product_rating_widget.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/error_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// View to let user select orderRating along with comments and product_ratings.
/// Consumer should land on this view when they tap on rating_indicator displayed in orders_list or order_details view.

class OrderFeedbackView extends StatelessWidget {
  final int ratingValue;
  OrderFeedbackView(this.ratingValue, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatch(ResetReviewRequest(ratingValue ?? 0));
        store.dispatch(GetOrderDetailsAPIAction(
            store.state.ordersState.selectedOrder?.orderId));
      },
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: tr("screen_order_feedback.rate_your_order"),
          ),
          bottomSheet: snapshot.isLoading || snapshot.hasError
              ? SizedBox.shrink()
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 58,
                      vertical: 20,
                    ),
                    child: ActionButton(
                      text: tr("screen_order_feedback.submit_feedback"),
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
                          OrderRatingCard(),
                          ProductRatingCard(),
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
  VoidCallback rateOrder;
  VoidCallback getOrderDetails;

  _ViewModel.build({
    this.isLoading,
    this.hasError,
    this.rateOrder,
    this.getOrderDetails,
  }) : super(equals: [isLoading]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      isLoading:
          state.ordersState.isLoadingOrderDetails == LoadingStatusApp.loading,
      hasError:
          state.ordersState.isLoadingOrderDetails == LoadingStatusApp.error,
      getOrderDetails: () => dispatch(
        GetOrderDetailsAPIAction(state.ordersState.selectedOrder?.orderId),
      ),
      rateOrder: () {
        if (state.ordersState.reviewRequest.ratingValue == null ||
            state.ordersState.reviewRequest.ratingValue <= 0) {
          Fluttertoast.showToast(
            msg: tr("screen_order_feedback.rate_order_message"),
          );
        } else {
          dispatch(NavigateAction.pop());
          dispatch(
            AddRatingAPIAction(
              request: state.ordersState.reviewRequest,
              orderId: state.ordersState.selectedOrderDetails.orderId,
            ),
          );
        }
      },
    );
  }
}
