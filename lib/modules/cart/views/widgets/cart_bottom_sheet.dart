part of "../cart.dart";

enum ORDER_TYPE { DELIVERY, STORE_PICKUP }

class CartBottomSheet extends StatelessWidget {
  final ORDER_TYPE orderType;
  const CartBottomSheet(this.orderType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      elevation: 4,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            height: 60,
            color: CustomTheme.of(context).colors.backgroundColor,
            child: Row(
              children: [
                Radio(
                  value: ORDER_TYPE.DELIVERY,
                  groupValue: orderType,
                  onChanged: (value) {},
                  activeColor: CustomTheme.of(context).colors.primaryColor,
                ),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      "Delivery at doorstep",
                      style: CustomTheme.of(context).textStyles.cardTitleFaded,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Radio(
                  value: ORDER_TYPE.STORE_PICKUP,
                  groupValue: orderType,
                  onChanged: (value) {},
                  activeColor: CustomTheme.of(context).colors.primaryColor,
                ),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      "Pickup at store",
                      style: CustomTheme.of(context).textStyles.cardTitleFaded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (orderType == ORDER_TYPE.STORE_PICKUP) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.pin_drop),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("business name"),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text("address address address address address"),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.pin_drop),
                            const SizedBox(width: 12),
                            Text("Delivering  to Home"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                            "Door No. 12 , Indiranagar,2nd cross road, Bangalore."),
                      ],
                    ),
                  ),
                  Text("change address"),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
