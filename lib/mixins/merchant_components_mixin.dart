import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';

///The [MerchantActionsProviderMixin] provides the common actions shared among components dealing
///with the business pages.

mixin MerchantActionsProviderMixin {
  void showContactMerchantDialog(BuildContext context,
      {Function onCallAction, Function onWhatsappAction, String merchantName}) {
    showModalBottomSheet(
        context: context,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9), topRight: Radius.circular(9)),
        ),
        builder: (context) => ContactBusinessDialogBuilder(
            onWhatsapp: onWhatsappAction,
            onCall: onCallAction,
            businessName: merchantName));
  }
}

class ContactBusinessDialogBuilder extends StatelessWidget {
  final VoidCallback onWhatsapp;
  final VoidCallback onCall;
  final String businessName;

  const ContactBusinessDialogBuilder(
      {Key key,
      @required this.onWhatsapp,
      @required this.onCall,
      @required this.businessName})
      : assert(businessName != null),
        assert(onCall != null),
        assert(onWhatsapp != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              title: new Text(
                'Call $businessName',
                style: CustomTheme.of(context).textStyles.cardTitle,
              ),
              leading: Icon(
                Icons.call,
                size: 25,
                color: CustomTheme.of(context).colors.positiveGreen,
              ),
              onTap: onCall),
          new ListTile(
            title: new Text('Whatsapp $businessName',
                style: CustomTheme.of(context).textStyles.cardTitle),
            leading: SizedBox(
              height: 25.toHeight,
              width: 25.toWidth,
              child: Image.asset('assets/images/whatsapp.png'),
            ),
            onTap: onWhatsapp,
          ),
        ],
      ),
    );
  }
}

class CircularAppLogo extends StatelessWidget {
  final double scaledHeight;
  final double currentHeight;

  const CircularAppLogo(
      {Key key, @required this.scaledHeight, this.currentHeight})
      : assert(scaledHeight != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox.fromSize(
        size: Size(scaledHeight, scaledHeight),
        child: Center(
          child: Transform.scale(
            scale: currentHeight != null ? currentHeight : 1.0,
            child: Container(
              decoration: ShapeDecoration(
                color: CustomTheme.of(context).colors.pureWhite,
                shadows: [
                   BoxShadow(
                      color: CustomTheme.of(context).colors.shadowColor,
                      blurRadius: AppSizes.widgetPadding,
                      spreadRadius: 0.0,
                      offset: Offset(0, 6))
                ],
                shape: const CircleBorder(),
              ),
              padding: EdgeInsets.all(scaledHeight / 6),
              child: Image.asset(
                'assets/images/app_main_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}