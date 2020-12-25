part of "../customer_note_images_view.dart";

class _ImageList extends StatelessWidget {
  final _ViewModel snapshot;
  const _ImageList(this.snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 176,
          child: snapshot.customerNoteImagesCount <= 3
              ? Row(
                  children: List.generate(
                    snapshot.customerNoteImagesCount,
                    (index) => Expanded(
                      child: _CustomCachedImage(
                        url: snapshot.customerNoteImages[index],
                        onRemove: () => snapshot.removeCustomerNoteImage(index),
                        showMargin:
                            index != snapshot.customerNoteImagesCount - 1,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: snapshot.customerNoteImagesCount,
                  itemBuilder: (context, index) => _CustomCachedImage(
                    url: snapshot.customerNoteImages[index],
                    width: 96,
                    onRemove: () => snapshot.removeCustomerNoteImage(index),
                    showMargin: index != snapshot.customerNoteImagesCount - 1,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              tr(
                "cart.n_images_added",
                args: [snapshot.customerNoteImagesCount.toString()],
              ),
              style: CustomTheme.of(context).textStyles.cardTitle,
            ),
            Spacer(),
            Text(
              tr("cart.max_images"),
              style: CustomTheme.of(context).textStyles.cardTitle,
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomCachedImage extends StatelessWidget {
  final String url;
  final double width;
  final VoidCallback onRemove;
  final bool showMargin;
  const _CustomCachedImage({
    @required this.url,
    @required this.onRemove,
    this.width,
    this.showMargin = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: showMargin ? 12 : 0),
      height: 176,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomTheme.of(context).colors.placeHolderColor,
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        height: 176,
        width: width,
        imageBuilder: (context, provider) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: provider,
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => CustomConfirmationDialog(
                  title: tr("cart.delete_image_alert_title"),
                  message: tr("cart.delete_image_alert_message"),
                  positiveButtonText: tr("address_picker.delete"),
                  positiveAction: () {
                    Navigator.pop(context);
                    onRemove();
                  },
                  actionButtonColor:
                      CustomTheme.of(context).colors.secondaryColor,
                  positiveButtonIcon: Icons.delete,
                  negativeButtonText: tr("screen_account.cancel"),
                  negativeAction: () => Navigator.pop(context),
                ),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 24,
                  width: 24,
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: CustomTheme.of(context).colors.disabledAreaColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => SizedBox.shrink(),
        placeholder: (_, __) => CupertinoActivityIndicator(),
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      color: CustomTheme.of(context).colors.placeHolderColor.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 34),
      child: Row(
        children: [
          Image.asset(
            ImagePathConstants.listUploadIcon,
            width: 60,
            fit: BoxFit.cover,
          ),
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
