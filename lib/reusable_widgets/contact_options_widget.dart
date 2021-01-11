import 'dart:io';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactOptionsWidget extends StatelessWidget {
  final String name;
  final String phoneNumber;
  const ContactOptionsWidget({
    @required this.name,
    @required this.phoneNumber,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
            title: new Text(
              'Call $name',
              style: CustomTheme.of(context).textStyles.cardTitle,
            ),
            leading: Icon(
              Icons.call,
              size: 25,
              color: CustomTheme.of(context).colors.positiveColor,
            ),
            onTap: () {
              if (phoneNumber == null) return;
              launch('tel:$phoneNumber');
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Text('Whatsapp $name',
                style: CustomTheme.of(context).textStyles.cardTitle),
            leading: SizedBox(
                height: 25.toHeight,
                width: 25.toWidth,
                child: Image.asset('assets/images/whatsapp.png')),
            onTap: () {
              if (phoneNumber == null) return;
              if (Platform.isIOS) {
                launch(
                    "whatsapp://wa.me/$phoneNumber/?text=${Uri.parse('Message from eSamudaay.')}");
              } else {
                launch(
                    "whatsapp://send?phone=$phoneNumber&text=${Uri.parse('Message from eSamudaay.')}");
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
