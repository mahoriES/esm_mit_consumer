class CartChargesType {
  static const String DELIVERY = "DELIVERY";
  static const String PACKING = "PACKING";
  static const String SERVICE = "TAX";
  static const String EXTRA = "EXTRA";
}

class CartCharges {
  Charge deliveryCharge;
  Charge packingCharge;
  Charge serviceCharge;
  Charge extraCharge;

  CartCharges({
    this.deliveryCharge,
    this.packingCharge,
    this.serviceCharge,
    this.extraCharge,
  });

  CartCharges.fromJson(List json) {
    if (json != null && json.isNotEmpty) {
      json.forEach((v) {
        Charge _charge = new Charge.fromJson(v);
        if (_charge.chargeName == CartChargesType.DELIVERY) {
          deliveryCharge = _charge;
        } else if (_charge.chargeName == CartChargesType.PACKING) {
          packingCharge = _charge;
        } else if (_charge.chargeName == CartChargesType.SERVICE) {
          serviceCharge = _charge;
        } else if (_charge.chargeName == CartChargesType.EXTRA) {
          extraCharge = _charge;
        }
      });
    }
  }

  toJson() {
    final List<Map<String, dynamic>> data = new List<Map<String, dynamic>>();
    if (deliveryCharge != null) {
      final Map<String, dynamic> _charge = new Map<String, dynamic>();
      _charge['name'] = this.deliveryCharge.chargeName;
      _charge['value'] = this.deliveryCharge.chargeValue;
      data.add(_charge);
    }
    if (packingCharge != null) {
      final Map<String, dynamic> _charge = new Map<String, dynamic>();
      _charge['name'] = this.packingCharge.chargeName;
      _charge['value'] = this.packingCharge.chargeValue;
      data.add(_charge);
    }
    if (serviceCharge != null) {
      final Map<String, dynamic> _charge = new Map<String, dynamic>();
      _charge['name'] = this.serviceCharge.chargeName;
      _charge['value'] = this.serviceCharge.chargeValue;
      data.add(_charge);
    }
    if (extraCharge != null) {
      final Map<String, dynamic> _charge = new Map<String, dynamic>();
      _charge['name'] = this.extraCharge.chargeName;
      _charge['value'] = this.extraCharge.chargeValue;
      data.add(_charge);
    }
    return data;
  }
}

class Charge {
  String businessId;
  String chargeName;
  int chargeValue;
  String chargeType;
  int maxValue;
  String chargeState;

  Charge(
      {this.businessId,
      this.chargeName,
      this.chargeValue,
      this.chargeType,
      this.maxValue,
      this.chargeState});

  Charge.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    chargeName = json['charge_name'] ?? json['name'];
    chargeValue = json['charge_value'] ?? json['value'];
    chargeType = json['charge_type'];
    maxValue = json['max_value'];
    chargeState = json['charge_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['charge_name'] = this.chargeName;
    data['charge_value'] = this.chargeValue;
    data['charge_type'] = this.chargeType;
    data['max_value'] = this.maxValue;
    data['charge_state'] = this.chargeState;
    return data;
  }

  double get amount {
    try {
      return (this.chargeValue ?? 0) / 100;
    } catch (e) {
      return 0.0;
    }
  }
}
