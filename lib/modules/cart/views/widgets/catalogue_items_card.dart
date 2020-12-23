part of "../cart.dart";

class _CatalogueItemCard extends StatelessWidget {
  final _ViewModel snapshot;
  const _CatalogueItemCard(this.snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("cart.catalogue_items"),
              style: CustomTheme.of(context).textStyles.body1,
            ),
            const SizedBox(height: 20),
            ListView.separated(
              itemCount: snapshot.productsCount,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, _) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final Product _currentProduct = snapshot.productsList[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentProduct.productName,
                            style: CustomTheme.of(context).textStyles.cardTitle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentProduct.selectedSkuWeight,
                            style: CustomTheme.of(context).textStyles.body2,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ProductCountWidget(
                        product: _currentProduct,
                        selectedMerchant: snapshot.cartMerchant,
                        isSku: true,
                        skuIndex: _currentProduct.selectedSkuIndex,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _currentProduct.selectedSkuPrice.withRupeePrefix,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Divider(
              color: CustomTheme.of(context).colors.dividerColor,
              thickness: 1,
              height: 0,
            ),
            const SizedBox(height: 20),
            _ChargesListView(snapshot),
          ],
        ),
      ),
    );
  }
}
