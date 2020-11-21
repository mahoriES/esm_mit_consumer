import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class LinkSharingService {
  AndroidParameters _androidParameters = AndroidParameters(
    packageName: StringConstants.packageName,
    minimumVersion: 16,
  );
  IosParameters _iosParameters = IosParameters(
    bundleId: StringConstants.packageName,
    appStoreId: StringConstants.appStoreId,
    // We will need to update the version number as per release status.
    // For now I have set it to 1.0.9 considerimg this feature would be included in next release.
    minimumVersion: "1.0.9",
  );

  Future<void> shareProductLink({
    @required String productId,
    @required String businessId,
    @required String storeName,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: StringConstants.sharingLinkPrefix,
      link: Uri.parse(StringConstants.productSharingLinkUrl(
        productId: productId,
        businessId: businessId,
      )),
      androidParameters: _androidParameters,
      iosParameters: _iosParameters,
      // socialMetaTagParameters are used as preview when this link is shared.
      socialMetaTagParameters: SocialMetaTagParameters(
        title:
            'Hello! You can now order online from $storeName using this link.',
        description:
            'You can pay online using GooglePay, PayTM, PhonePe, UPI apps or Cash on delivery.',
        //  this url refers to the esamudaay logo.
        imageUrl: Uri.parse(
          'https://lh3.googleusercontent.com/b5-o56HDsZhnCfYavGxGcfZHmZp51AzbzXQXllZ19FlVyIwhMI9i0fFuTu_9oe1MYlQ=s180',
        ),
      ),
    );

    await _shareLink(parameters: parameters);
  }

  _shareLink({
    @required DynamicLinkParameters parameters,
  }) async {
    Uri dynamicUrl;
    try {
      dynamicUrl = (await parameters.buildShortLink()).shortUrl;
    } catch (e) {
      dynamicUrl = await parameters.buildUrl();
    }
    Share.share(dynamicUrl.toString());
  }
}
