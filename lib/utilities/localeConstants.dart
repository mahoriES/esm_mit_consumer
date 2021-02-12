import 'package:flutter/material.dart';

///IMPORTANT :
///For any index i; languagesList[i] and localeList[i] MUST correspond to same
///language.
///This is essential as we use locale to show the label for the selected language

class LocaleConstants {

  static List<String> get languagesList {
    return const <String>[
      "English",
      "Hindi (हिन्दी)",
      "Kannada (ಕನ್ನಡ)",
      "Tamil (தமிழ்)",
      "Telugu (తెలుగు)",
    ];
  }

  static List<Locale> get localeList {
    return const <Locale>[
      Locale('en', 'US'),
      Locale.fromSubtags(languageCode: 'hi', countryCode: 'Deva-IN'),
      Locale('ka', 'IN'),
      Locale('ta', 'IN'),
      Locale('te', 'IN'),
    ];
  }

}