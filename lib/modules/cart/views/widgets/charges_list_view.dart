part of "../cart.dart";

class _ChargesListView extends StatelessWidget {
  final _ViewModel snapshot;
  _ChargesListView(this.snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey deliveryChargeKey = new GlobalKey();
    GlobalKey merchantChargeKey = new GlobalKey();

    _getPositions(GlobalKey key) {
      final RenderBox renderBox = key.currentContext.findRenderObject();
      final position = renderBox.localToGlobal(Offset.zero);
      print("POSITION of : $position ");

      snapshot._overlayEntry = new OverlayEntry(
        maintainState: true,
        builder: (context) => Positioned(
          top: position.dy - 60,
          left: position.dx,
          child: Card(
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: SizeConfig.screenWidth / 2,
              ),
              padding: EdgeInsets.all(12),
              child: Text(
                tr("cart.delivery_charge_info"),
                style: CustomTheme.of(context).textStyles.body2Faded,
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(snapshot._overlayEntry);
    }

    return Column(
      children: [
        _ChargesListItem(
          chargeName: tr("cart.item_total"),
          price: snapshot.getCartTotal,
        ),
        const SizedBox(height: 12),
        Container(
          key: deliveryChargeKey,
          child: _ChargesListItem(
            chargeName: tr("cart.delivery_partner_fee"),
            price: snapshot.deliveryCharge,
            showInfo: () {
              _getPositions(deliveryChargeKey);
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          key: merchantChargeKey,
          child: _ChargesListItem(
            chargeName: tr("cart.merchant_charges"),
            price: snapshot.merchantCharge,
            showInfo: () {
              _getPositions(merchantChargeKey);
            },
          ),
        ),
        const SizedBox(height: 20),
        Divider(
          color: CustomTheme.of(context).colors.dividerColor,
          thickness: 1,
          height: 0,
        ),
        const SizedBox(height: 20),
        _ChargesListItem(
          chargeName: tr("cart.grand_total"),
          price: snapshot.grandTotal,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ChargesListItem extends StatelessWidget {
  final String chargeName;
  final double price;
  final VoidCallback showInfo;
  const _ChargesListItem({
    @required this.chargeName,
    @required this.price,
    this.showInfo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: showInfo,
            child: Text(
              chargeName,
              style: CustomTheme.of(context).textStyles.body1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            price.withRupeePrefix,
            style: CustomTheme.of(context).textStyles.body1,
          ),
        ),
      ],
    );
  }
}

class _MerchantChargesInfo extends StatelessWidget {
  final double packingCharge;
  final double serviceCharge;
  const _MerchantChargesInfo({
    @required this.packingCharge,
    @required this.serviceCharge,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, double> _merchantChargesName = {
      "packing_charges": packingCharge,
      "service_charges": serviceCharge,
    };

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("cart.merchant_charges"),
              style: CustomTheme.of(context).textStyles.body1,
            ),
            const SizedBox(height: 4),
            Divider(
              color: CustomTheme.of(context).colors.dividerColor,
              thickness: 1,
              height: 0,
            ),
            const SizedBox(height: 8),
            ListView.separated(
              itemCount: _merchantChargesName.keys.length,
              shrinkWrap: true,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _ChargesListItem(
                chargeName:
                    tr("cart.${_merchantChargesName.keys.elementAt(index)}"),
                price: _merchantChargesName.values.elementAt(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
