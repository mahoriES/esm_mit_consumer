class CommonMethods {
  static String priceFormat(double amount) {
    if (amount == null) return "NA";
    return "\u{20B9} $amount";
  }
}
