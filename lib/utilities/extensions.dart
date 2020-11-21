extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension ToRupee on int {
  double get toRupee => this == null ? 0 : this / 100;
}
