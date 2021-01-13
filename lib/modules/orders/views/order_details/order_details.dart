import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/bottom_widget.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/order_summary_card/order_summary_card.dart';
import 'package:eSamudaay/modules/orders/views/order_details/widgets/status_card.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/error_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatch(GetOrderDetailsAPIAction(
          store.state.ordersState.selectedOrderForDetails?.orderId,
        ));
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
              : OrderDetailsBottomWidget(snapshot.orderDetails),
          body: snapshot.isLoading
              ? LoadingIndicator()
              : snapshot.hasError
                  ? Center(child: GenericErrorView(snapshot.getOrderDetails))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          OrderDetailsStatusCard(),
                          OrderSummaryCard(),
                          const SizedBox(height: 200),
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
      selectedOrder: state.ordersState.selectedOrderForDetails,
      orderDetails: state.ordersState.selectedOrderDetailsResponse,
      getOrderDetails: () => dispatch(
        GetOrderDetailsAPIAction(
            state.ordersState.selectedOrderForDetails?.orderId),
      ),
    );
  }
}
