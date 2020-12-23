part of "../cart.dart";

class _ListImagesWidget extends StatelessWidget {
  final _ViewModel snapshot;
  const _ListImagesWidget(this.snapshot, {Key key}) : super(key: key);

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
              tr("cart.list_items"),
              style: CustomTheme.of(context).textStyles.body1,
            ),
            const SizedBox(height: 20),
            _ListImagePlaceHolder(),
            const SizedBox(height: 16),
            ActionButton(
              text: tr("cart.upload_list"),
              icon: Icons.camera,
              onTap: () {},
              isDisabled: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ListImagePlaceHolder extends StatelessWidget {
  const _ListImagePlaceHolder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124.toHeight,
      color: CustomTheme.of(context).colors.placeHolderColor.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: 34.toWidth,
        vertical: 34.toHeight,
      ),
      child: Row(
        children: [
          Icon(Icons.list),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              tr("cart.list_placeholder_message"),
              style: CustomTheme.of(context).textStyles.cardTitleFaded,
            ),
          ),
        ],
      ),
    );
  }
}
