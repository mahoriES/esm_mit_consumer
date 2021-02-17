import 'package:eSamudaay/modules/address/view/widgets/action_button.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:flutter/material.dart';

class PaymentOptionsData {
  String optionName;
  String details;
  String image;

  PaymentOptionsData({
    @required this.optionName,
    @required this.details,
    @required this.image,
  });
}

class PaymentOptionsWidget extends StatelessWidget {
  final bool showBackOption;
  const PaymentOptionsWidget({this.showBackOption = true, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PaymentOptionsData> paymentOptions = [
      new PaymentOptionsData(
        optionName: "Razor Pay",
        details: "Online Payment options",
        image: ImagePathConstants.razorpayLogo,
      ),
      new PaymentOptionsData(
        optionName: "Cash On Delivery / Pickup",
        details: "Pay cash on receiving the order",
        image: ImagePathConstants.cashIcon,
      ),
    ];

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
                "Bill Total: ₹ 518.00",
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
              itemCount: paymentOptions.length,
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio(
                    value: index,
                    groupValue: 1,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: CustomTheme.of(context).colors.primaryColor,
                    onChanged: (v) {},
                  ),
                  title: Row(
                    children: [
                      Image.asset(
                        paymentOptions[index].image,
                        width: 35,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 18),
                      Text.rich(
                        TextSpan(
                          text: paymentOptions[index].optionName,
                          style: CustomTheme.of(context).textStyles.cardTitle,
                          children: [
                            TextSpan(
                              text: "\n" + paymentOptions[index].details,
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
          // Spacer(),
          const SizedBox(height: 8),
          ActionButton(
            text: "Confirm Order",
            icon: Icons.check_circle_outline,
            isFilled: true,
            buttonColor: CustomTheme.of(context).colors.positiveColor,
            textColor: CustomTheme.of(context).colors.backgroundColor,
            onTap: null,
          ),
        ],
      ),
    );
  }
}
