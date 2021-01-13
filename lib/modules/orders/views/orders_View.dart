import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_models.dart';
import 'package:eSamudaay/modules/orders/views/widgets/feedback_submit_dialog.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/reusable_widgets/custom_app_bar.dart';
import 'package:eSamudaay/reusable_widgets/error_view.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'no_orders_view/no_orders_view.dart';
import 'order_card/orders_card.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr("screen_order.your_orders"),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          store.dispatch(GetOrderListAPIAction());
        },
        onDidChange: (snapshot) {
          snapshot.resetShowFeedbackDialog();
          if (snapshot.showFeedbackDialog) {
            showDialog(
              context: context,
              builder: (context) => FeedbackSubmissionDialog(),
            );
          }
        },
        builder: (context, snapshot) {
          return ModalProgressHUD(
            progressIndicator: LoadingIndicator(),
            inAsyncCall: snapshot.isLoadingOrderList,
            child: snapshot.hasError
                ? GenericErrorView(() => snapshot.fetchOrdersList())
                : !snapshot.isLoadingOrderList && snapshot.isOrdersListEmpty
                    ? NoOrdersView()
                    : Container(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: WaterDropHeader(
                            complete: LoadingIndicator(),
                            waterDropColor:
                                CustomTheme.of(context).colors.primaryColor,
                            refresh: LoadingIndicator(),
                          ),
                          footer: CustomFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                            builder: (BuildContext context, LoadStatus mode) =>
                                LoadingIndicator(),
                          ),
                          controller: refreshController,
                          onRefresh: () =>
                              snapshot.onRefresh(refreshController),
                          onLoading: () =>
                              snapshot.onLoading(refreshController),
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 30),
                            shrinkWrap: true,
                            itemCount:
                                snapshot.getOrderListResponse.results.length,
                            itemBuilder: (BuildContext context, int index) =>
                                OrdersCard(
                              snapshot.getOrderListResponse.results[index],
                            ),
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  GetOrderListResponse getOrderListResponse;
  bool isLoadingOrderList;
  bool isLoadingNextPage;
  bool hasError;
  bool showFeedbackDialog;
  Future Function({String url}) fetchOrdersList;
  VoidCallback resetShowFeedbackDialog;

  _ViewModel();

  _ViewModel.build({
    this.getOrderListResponse,
    this.isLoadingOrderList,
    this.isLoadingNextPage,
    this.hasError,
    this.fetchOrdersList,
    this.showFeedbackDialog,
    this.resetShowFeedbackDialog,
  }) : super(equals: [
          getOrderListResponse,
          isLoadingOrderList,
          isLoadingNextPage,
          showFeedbackDialog,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      fetchOrdersList: ({String url}) async {
        await dispatchFuture(
          GetOrderListAPIAction(urlForNextPageResponse: url),
        );
      },
      showFeedbackDialog: state.ordersState.showFeedbackSubmitDialog,
      isLoadingOrderList:
          state.ordersState.isLoadingOrdersList == LoadingStatusApp.loading,
      hasError: state.ordersState.isLoadingOrdersList == LoadingStatusApp.error,
      isLoadingNextPage:
          state.ordersState.isLoadingNextPage == LoadingStatusApp.loading,
      getOrderListResponse: state.ordersState.getOrderListResponse,
      resetShowFeedbackDialog: () => dispatch(ResetShowFeedbackDialog()),
    );
  }

  bool get isOrdersListEmpty =>
      getOrderListResponse == null ||
      getOrderListResponse.results == null ||
      getOrderListResponse.results.isEmpty;

  void onRefresh(RefreshController refreshController) async {
    await fetchOrdersList();
    refreshController.refreshCompleted();
  }

  void onLoading(RefreshController refreshController) async {
    if (getOrderListResponse.next != null) {
      await fetchOrdersList(url: getOrderListResponse.next);
    } else {
      Fluttertoast.showToast(msg: tr("screen_order.no_more_orders"));
    }
    refreshController.loadComplete();
  }
}
