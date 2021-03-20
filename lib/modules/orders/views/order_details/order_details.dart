import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/bottom_widget.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_summary_card/order_summary_card.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_details_status_card/order_details_status_card.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/error_view.dart';
import 'package:eSamudaay/reusable_widgets/payment_options_widget.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({Key key}) : super(key: key);

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        await store.dispatchFuture(GetOrderDetailsAPIAction(
          store.state.ordersState.selectedOrder?.orderId,
        ));

        // if payment is pending to complete order placement, pop payment tile when user navigates to order details .
        if (store.state.ordersState.selectedOrder?.orderStatus ==
            OrderState.CUSTOMER_PENDING) {
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (context) => PaymentOptionsWidget(
              showBackOption: true,
              orderDetails: store.state.ordersState.selectedOrderDetails,
              onPaymentSuccess: () {},
            ),
          );
        }
      },
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title:
                "${tr('screen_order.order_no')} #${snapshot.selectedOrder.orderShortNumber}",
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      "${snapshot.selectedOrder.createdTime}\t\t\t\t${snapshot.selectedOrder.createdDate}",
                      style: CustomTheme.of(context).textStyles.body2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: snapshot.isLoading || snapshot.hasError
              ? SizedBox.shrink()
              : OrderDetailsBottomWidget(),
          body: snapshot.isLoading
              ? LoadingIndicator()
              : snapshot.hasError
                  ? Center(child: GenericErrorView(snapshot.getOrderDetails))
                  : SmartRefresher(
                      enablePullDown: true,
                      header: WaterDropHeader(
                        complete: LoadingIndicator(),
                        waterDropColor:
                            CustomTheme.of(context).colors.primaryColor,
                        refresh: LoadingIndicator(),
                      ),
                      controller: refreshController,
                      onRefresh: () => snapshot.onRefresh(refreshController),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            OrderDetailsStatusCard(),
                            OrderSummaryCard(),
                            const SizedBox(height: 200),
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

  bool isLoading;
  bool hasError;
  PlaceOrderResponse selectedOrder;
  PlaceOrderResponse orderDetails;
  VoidCallback getOrderDetails;

  _ViewModel.build({
    this.isLoading,
    this.hasError,
    this.selectedOrder,
    this.orderDetails,
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
      selectedOrder: state.ordersState.selectedOrder,
      orderDetails: state.ordersState.selectedOrderDetails,
      getOrderDetails: () => dispatch(
        GetOrderDetailsAPIAction(
            state.ordersState.selectedOrderDetails?.orderId),
      ),
    );
  }

  void onRefresh(RefreshController refreshController) async {
    getOrderDetails();
    refreshController.refreshCompleted();
  }
}
