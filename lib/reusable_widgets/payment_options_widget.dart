import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class PaymentOptionsWidget extends StatelessWidget {
  final bool showBackOption;
  final PlaceOrderResponse orderDetails;
  final VoidCallback onPaymentSuccess;
  const PaymentOptionsWidget({
    this.showBackOption = true,
    @required this.orderDetails,
    @required this.onPaymentSuccess,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) async {
        await store.dispatchFuture(ResetSelectedOrder(orderDetails));
      },
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBackOption ?? true) ...[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: CustomTheme.of(context).colors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 18),
                  ],
                  Text(
                    tr("payment_options.bill_total") +
                        ": " +
                        snapshot.totalAmount.withRupeePrefix,
                    style: CustomTheme.of(context).textStyles.topTileTitle,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                tr("payment_options.select_payment_method"),
                style: CustomTheme.of(context).textStyles.sectionHeading2,
              ),
              const Divider(height: 16, thickness: 1),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: snapshot.paymentOptionsList.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    _PaymentOptionsData _paymentOptionData =
                        snapshot.paymentOptionsList[index];

                    return RadioListTile(
                      value: _paymentOptionData.value,
                      groupValue: snapshot.selectedPaymentOption,
                      activeColor: CustomTheme.of(context).colors.primaryColor,
                      onChanged: _paymentOptionData.isEnabled
                          ? snapshot.changeSelectedPaymentOption
                          : null,
                      title: Row(
                        children: [
                          Image.asset(
                            _paymentOptionData.image,
                            width: 35,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(width: 18),
                          Text.rich(
                            TextSpan(
                              text: _paymentOptionData.optionName,
                              style: _paymentOptionData.isEnabled
                                  ? CustomTheme.of(context).textStyles.cardTitle
                                  : CustomTheme.of(context)
                                      .textStyles
                                      .cardTitleFaded,
                              children: [
                                TextSpan(
                                  text: "\n" + _paymentOptionData.details,
                                  style: (_paymentOptionData.isEnabled
                                          ? CustomTheme.of(context)
                                              .textStyles
                                              .body2
                                          : CustomTheme.of(context)
                                              .textStyles
                                              .body2Faded)
                                      .copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              ActionButton(
                text: tr("payment_options.pay") +
                    " " +
                    snapshot.totalAmount.withRupeePrefix,
                icon: Icons.check_circle_outline,
                isFilled: true,
                buttonColor: CustomTheme.of(context).colors.positiveColor,
                textColor: CustomTheme.of(context).colors.backgroundColor,
                onTap: () {
                  snapshot
                      .payForOrder(onPaymentSuccess)
                      .timeout(const Duration(seconds: 10));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  bool isCodAvailable;
  PaymentOptions selectedPaymentOption;
  double totalAmount;
  Function(PaymentOptions) changeSelectedPaymentOption;
  Future<void> Function(VoidCallback) payForOrder;

  _ViewModel.build({
    this.isCodAvailable,
    this.selectedPaymentOption,
    this.totalAmount,
    this.changeSelectedPaymentOption,
    this.payForOrder,
  }) : super(equals: [selectedPaymentOption]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      isCodAvailable:
          !state.ordersState.selectedOrder.paymentInfo.payBeforeOrder,
      selectedPaymentOption: state.ordersState.selectedPaymentOption,
      totalAmount: state.ordersState.selectedOrder.orderTotalPriceInRupees ?? 0,
      changeSelectedPaymentOption: (paymentOption) => dispatch(
        ChangeSelctedPaymentOption(paymentOption),
      ),
      payForOrder: (onPaymentSucces) async {
        dispatch(NavigateAction.pop());
        if (state.ordersState.selectedPaymentOption == PaymentOptions.COD) {
          // when COD option is selected.
        } else {
          await dispatchFuture(
            PaymentAction(
              orderId: state.ordersState.selectedOrder.orderId,
              onSuccess: (isPaymentDone) {
                if (isPaymentDone) {
                  onPaymentSucces();
                }
              },
            ),
          );
        }
      },
    );
  }

  List<_PaymentOptionsData> get paymentOptionsList {
    return [
      new _PaymentOptionsData(
        optionName: tr("payment_options.razor_pay"),
        details: tr("payment_options.online_payment_options"),
        image: ImagePathConstants.razorpayLogo,
        value: PaymentOptions.Razorpay,
        isEnabled: true,
      ),
      new _PaymentOptionsData(
        optionName: tr("payment_options.pay_on_delivery"),
        details: tr("payment_options.pay_on_delivery_message"),
        image: isCodAvailable
            ? ImagePathConstants.cashIcon
            : ImagePathConstants.cashGreyIcon,
        value: PaymentOptions.COD,
        isEnabled: isCodAvailable,
      ),
    ];
  }
}

class _PaymentOptionsData {
  String optionName;
  String details;
  String image;
  PaymentOptions value;
  bool isEnabled;

  _PaymentOptionsData({
    @required this.optionName,
    @required this.details,
    @required this.image,
    @required this.value,
    @required this.isEnabled,
  });
}
