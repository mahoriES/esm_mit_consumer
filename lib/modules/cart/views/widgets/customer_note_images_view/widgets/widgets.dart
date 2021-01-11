import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class CustomerNoteImageView extends StatelessWidget {
  final List<String> customerNoteImages;
  final Function(int) onRemove;
  final bool showRemoveButton;
  const CustomerNoteImageView({
    @required this.customerNoteImages,
    @required this.onRemove,
    this.showRemoveButton = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 176,
          child: customerNoteImages.length <= 3
              ? Row(
                  children: List.generate(
                    customerNoteImages.length,
                    (index) => Expanded(
                      child: _CustomCachedImage(
                        url: customerNoteImages[index],
                        onRemove: () => onRemove(index),
                        showMargin: index != customerNoteImages.length - 1,
                        showRemoveButton: showRemoveButton,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: customerNoteImages.length,
                  itemBuilder: (context, index) => _CustomCachedImage(
                    url: customerNoteImages[index],
                    width: 96,
                    onRemove: () => onRemove(index),
                    showMargin: index != (customerNoteImages.length - 1),
                    showRemoveButton: showRemoveButton,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              tr(
                "cart.n_images_added",
                args: [customerNoteImages.length.toString()],
              ),
              style: CustomTheme.of(context).textStyles.cardTitle,
            ),
            Spacer(),
            if (showRemoveButton) ...{
              Text(
                tr("cart.max_images"),
                style: CustomTheme.of(context).textStyles.cardTitle,
              ),
            }
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
  final bool showRemoveButton;
  const _CustomCachedImage({
    @required this.url,
    @required this.onRemove,
    @required this.showRemoveButton,
    this.width,
    this.showMargin = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.IMAGE_ZOOM_VIEW,
        arguments: url,
      ),
      child: Container(
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
            child: showRemoveButton
                ? Align(
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
                              color: CustomTheme.of(context)
                                  .colors
                                  .disabledAreaColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          errorWidget: (_, __, ___) => SizedBox.shrink(),
          placeholder: (_, __) => CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class CustomerNoteImagePlaceHolder extends StatelessWidget {
  const CustomerNoteImagePlaceHolder({Key key}) : super(key: key);

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
