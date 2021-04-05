import 'package:easy_localization/easy_localization.dart';

class Validators {
  static String nullStringValidator(String input) {
    // returning empty string on error as it would highlight the error by marking input field as red so didn't feel a need to show a message also.
    // maybe we can modify it later as needed.
    if (input == null || input == "") return "";
    return null;
  }

  static String nameValidator(String input) {
    if (input == null || input.length < 3)
      return tr('screen_register.name.empty_error');
    return null;
  }

  static String userNameValidator(String input) {
    if (input == null || input.length < 1)
      return tr('screen_register.name.empty_error');
    return null;
  }
}
