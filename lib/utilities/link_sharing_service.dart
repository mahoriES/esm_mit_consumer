import 'package:eSamudaay/utilities/stringConstants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

//TODO: This class is shared between consumer and merchant apps, so need to be wrapped into a package to use in common

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

  Future<void>shareBusinessLink({@required String businessId, @required String storeName}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: StringConstants.sharingLinkPrefix,
      link: Uri.parse(StringConstants.businessSharingLinkUrl(
        businessId: businessId,
      )),
      androidParameters: _androidParameters,
      iosParameters: _iosParameters,
      // socialMetaTagParameters are used as preview when this link is shared.
      socialMetaTagParameters: SocialMetaTagParameters(
        title: StringConstants.linkPreviewTitle(storeName),
        description: StringConstants.linkPreviewMessage,
        imageUrl: Uri.parse(StringConstants.esamudaayLogoUrl),
      ),
    );

    await _shareLink(parameters: parameters);
  }

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
        title: StringConstants.linkPreviewTitle(storeName),
        description: StringConstants.linkPreviewMessage,
        imageUrl: Uri.parse(StringConstants.esamudaayLogoUrl),
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
