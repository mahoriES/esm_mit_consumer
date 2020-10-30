
import 'package:easy_localization/easy_localization.dart';

///This class acts as an interface between the backend keys for charges and user-friendly charges string
///by a 1 on 1 mapping between the both.

enum AdditionalChargeType {
  deliveryCharge,
  extraCharge,
  packingCharge,
  serviceCharge,
}

class AdditionChargesMetaDataGenerator {
  static AdditionChargesMetaDataGenerator _instance;

  AdditionChargesMetaDataGenerator._internal() {
    _instance = this;
  }

  factory AdditionChargesMetaDataGenerator() =>
      _instance ?? AdditionChargesMetaDataGenerator._internal();

  static String keyFromEnumValue(AdditionalChargeType chargeType) {
    switch (chargeType) {
      case AdditionalChargeType.deliveryCharge:
        return 'DELIVERY';
        break;
      case AdditionalChargeType.extraCharge:
        return 'EXTRA';
        break;
      case AdditionalChargeType.packingCharge:
        return 'PACKING';
        break;
      case AdditionalChargeType.serviceCharge:
        return 'SERVICE';
        break;
      default:
        return 'OTHER';
    }
  }

  static List<String> get allKeyOptions =>
      ['DELIVERY', 'EXTRA', 'PACKING', 'SERVICE'];

  static String friendlyChargeNameFromEnumValue(
      AdditionalChargeType chargeType) {
    switch (chargeType) {
      case AdditionalChargeType.deliveryCharge:
        return tr('charges_name.delivery');
        break;
      case AdditionalChargeType.extraCharge:
        return tr('charges_name.extra');
        break;
      case AdditionalChargeType.packingCharge:
        return tr('charges_name.packing');
        break;
      case AdditionalChargeType.serviceCharge:
        return tr('charges_name.service');
        break;
      default:
        return tr('charges_name.other');
    }
  }

  static String friendlyChargeNameFromKeyValue(String key) {
    switch (key) {
      case 'DELIVERY':
        return tr('charges_name.delivery');
        break;
      case 'EXTRA':
        return tr('charges_name.extra');
        break;
      case 'PACKING':
        return tr('charges_name.packing');
        break;
      case 'SERVICE':
        return tr('charges_name.service');
        break;
      default:
        return tr('charges_name.other');
    }
  }
}