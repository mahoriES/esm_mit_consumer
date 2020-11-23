extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension ConvertPaisaToRupee on int {
  double get paisaToRupee => this == null ? 0 : this / 100;
}

extension AddRupeePrefix on num {
  String get withRupeePrefix =>
      this == null ? "NA" : "\u{20B9} ${this?.toStringAsFixed(2)}";
}
