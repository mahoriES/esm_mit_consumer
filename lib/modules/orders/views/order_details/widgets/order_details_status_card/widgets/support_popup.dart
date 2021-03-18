import 'dart:math';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/models/cart_model.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPopup extends StatelessWidget {
  const SupportPopup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {
        return Card(
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            width: min(320, SizeConfig.screenWidth - 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("support.need_help"),
                      style: CustomTheme.of(context).textStyles.cardTitle,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () =>
                          launch('tel:${snapshot.supportPersonContact}'),
                      child: Row(
                        children: [
                          Image.asset(
                            ImagePathConstants.callIcon,
                            width: 20,
                          ),
                          SizedBox(width: 15),
                          Text(
                            tr("support.call_cp") +
                                "\n${snapshot.supportPersonName} ${snapshot.supportPersonContact}",
                            style:
                                CustomTheme.of(context).textStyles.body2Faded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  child: Icon(
                    Icons.clear,
                    size: 16,
                    color: CustomTheme.of(context).colors.disabledAreaColor,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  PlaceOrderResponse selectedOrderDetails;

  _ViewModel.build({this.selectedOrderDetails});

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      selectedOrderDetails: state.ordersState.selectedOrderDetails,
    );
  }

  String get orderBusinessName => selectedOrderDetails.businessName ?? "";
  String get orderBusinessContact =>
      selectedOrderDetails.businessContactNumber ?? "";

  String get supportPersonName {
    String cpName;

    if (selectedOrderDetails?.cpInfo == null ||
        selectedOrderDetails.cpInfo.isEmpty) return orderBusinessName;

    for (final cpInfo in selectedOrderDetails.cpInfo) {
      if (!cpInfo.isSuspended) {
        cpName = cpInfo.profileName;
        break;
      }
    }

    return cpName ?? orderBusinessName;
  }

  String get supportPersonContact {
    String cpContact;

    if (selectedOrderDetails?.cpInfo == null ||
        selectedOrderDetails.cpInfo.isEmpty) return orderBusinessContact;

    for (final cpInfo in selectedOrderDetails.cpInfo) {
      if (!cpInfo.isSuspended) {
        cpContact = cpInfo.phone;
        break;
      }
    }

    return cpContact ?? orderBusinessContact;
  }
}
