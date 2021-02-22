import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/modules/orders/actions/actions.dart';
import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class PaymentOptionsWidget extends StatelessWidget {
  final bool showBackOption;
  final bool isCodAvailable;
  final VoidCallback onPaymentSuccess;
  const PaymentOptionsWidget({
    this.showBackOption = true,
    this.isCodAvailable = true,
    this.onPaymentSuccess,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(isCodAvailable),
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
                    "Bill Total: " + snapshot.totalAmount.withRupeePrefix,
                    style: CustomTheme.of(context).textStyles.topTileTitle,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                "Select Payment Method",
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

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Radio<PaymentOptions>(
                        value: _paymentOptionData.value,
                        groupValue: snapshot.selectedPaymentOption,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor:
                            CustomTheme.of(context).colors.primaryColor,
                        onChanged: _paymentOptionData.isEnabled
                            ? snapshot.changeSelectedPaymentOption
                            : null,
                      ),
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
                              style:
                                  CustomTheme.of(context).textStyles.cardTitle,
                              children: [
                                TextSpan(
                                  text: "\n" + _paymentOptionData.details,
                                  style: CustomTheme.of(context)
                                      .textStyles
                                      .body2
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
                text: "Pay " + snapshot.totalAmount.withRupeePrefix,
                icon: Icons.check_circle_outline,
                isFilled: true,
                buttonColor: CustomTheme.of(context).colors.positiveColor,
                textColor: CustomTheme.of(context).colors.backgroundColor,
                onTap: () => snapshot.payForOrder(onPaymentSuccess),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  final bool isCodAvailable;
  _ViewModel(this.isCodAvailable);

  PaymentOptions selectedPaymentOption;
  double totalAmount;
  Function(PaymentOptions) changeSelectedPaymentOption;
  Function(VoidCallback) payForOrder;

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
      isCodAvailable: this.isCodAvailable,
      selectedPaymentOption: state.ordersState.selectedPaymentOption,
      totalAmount:
          state.ordersState.selectedOrderDetails.orderTotalPriceInRupees ?? 0,
      changeSelectedPaymentOption: (paymentOption) => dispatch(
        ChangeSelctedPaymentOption(paymentOption),
      ),
      payForOrder: (onPaymentSucces) {
        if (state.ordersState.selectedPaymentOption == PaymentOptions.COD) {
          // when COD option is selected.
        } else {
          NavigateAction.pop();
          dispatch(
            PaymentAction(
              orderId: state.ordersState.selectedOrderDetails.orderId,
              onSuccess: () async {
                await dispatchFuture(
                  GetOrderDetailsAPIAction(
                      state.ordersState.selectedOrderDetails.orderId),
                );
                if (store.state.ordersState.selectedOrderDetails.paymentInfo
                    .isPaymentDone) {
                  debugPrint("payment is done");
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
        optionName: "Razor Pay",
        details: "Online Payment options",
        image: ImagePathConstants.razorpayLogo,
        value: PaymentOptions.Razorpay,
        isEnabled: true,
      ),
      new _PaymentOptionsData(
        optionName: "Cash On Delivery / Pickup",
        details: "Pay cash on receiving the order",
        image: ImagePathConstants.cashIcon,
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
