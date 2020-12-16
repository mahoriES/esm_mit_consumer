import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/extensions.dart';

class MerchantAddressRow extends StatelessWidget {
  final String address;
  final String phoneNumber;
  final VoidCallback onContactMerchant;
  final VoidCallback onOpenMap;

  const MerchantAddressRow(
      {Key key,
      @required this.address,
      @required this.phoneNumber,
      @required this.onContactMerchant,
      @required this.onOpenMap})
      : assert(address != null),
        assert(phoneNumber != null),
        assert(onContactMerchant != null),
        assert(onOpenMap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.widgetPadding),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: onOpenMap,
              child: ImageIcon(
                AssetImage(
                  'assets/images/location2.png',
                ),
                color: CustomTheme.of(context).colors.primaryColor,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onOpenMap,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.separatorPadding / 2,
                      right: AppSizes.separatorPadding / 2),
                  child: Text(address,
                      style: CustomTheme.of(context).textStyles.sectionHeading1,
                      textAlign: TextAlign.left),
                ),
              ),
            ),
            ContactMerchantActionButton(onContactMerchant: onContactMerchant),
            const SizedBox(
              width: AppSizes.separatorPadding,
            ),
            GestureDetector(
              onTap: onContactMerchant,
              child: Text(phoneNumber.formatPhoneNumber,
                  style: CustomTheme.of(context).textStyles.sectionHeading1,
                  textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactMerchantActionButton extends StatelessWidget {
  final VoidCallback onContactMerchant;

  const ContactMerchantActionButton({Key key, @required this.onContactMerchant})
      : assert(onContactMerchant != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onContactMerchant,
        child: Icon(
          Icons.phone_outlined,
          color: CustomTheme.of(context).colors.primaryColor,
          size: 22,
        ),
      ),
    );
  }
}

class ShareBusinessActionButton extends StatelessWidget {
  final VoidCallback onShare;

  const ShareBusinessActionButton({Key key, @required this.onShare})
      : assert(onShare != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
          onTap: onShare,
          child: Icon(
            Icons.share,
            color: CustomTheme.of(context).colors.primaryColor,
          )),
    );
  }
}
