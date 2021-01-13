extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension ConvertPaisaToRupee on int {
  double get paisaToRupee => this == null ? 0 : this / 100;
}

extension AddRupeePrefix on num {
  String get withRupeePrefix =>
      this == null ? "NA" : "\u{20B9} ${this?.toStringAsFixed(2)}";
}

extension AddRupeePrefixForStringifiedPrice on String {
  String get withRupeePrefix => this == null ? "NA" : "\u{20B9} $this";
}

extension StringUtils on String {
  String get formatPhoneNumber {
    if (int.tryParse(this) == null) return this;
    if (this.length > 3 && this.substring(0, 3) != "+91") return "+91" + this;
    return this;
  }

  String get formatCustomerNote {
    if (this.length > 127) {
      //Note is modified here if length is beyond 127 characters
      return this.substring(0, 128) + '..';
    } else
      return this;
  }
}
