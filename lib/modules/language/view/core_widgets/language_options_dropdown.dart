import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/firebase_analytics.dart';
import 'package:eSamudaay/utilities/localeConstants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class LanguageOptionsDropDown extends StatefulWidget {
  final Function fromAccountAction;
  final bool fromAccount;

  const LanguageOptionsDropDown(
      {Key key, @required this.fromAccountAction, @required this.fromAccount})
      : super(key: key);

  @override
  _LanguageOptionsDropDownState createState() =>
      _LanguageOptionsDropDownState();
}

class _LanguageOptionsDropDownState extends State<LanguageOptionsDropDown> {
  bool _isExpanded;
  final TextEditingController _textEditingController = TextEditingController();
  Locale selectedLocale;
  String selectedLanguage;

  @override
  void initState() {
    _isExpanded = false;
    _textEditingController
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpanded) {
      return Container(
        width: 351.toWidth,
        height: 426.toHeight,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: CustomTheme.of(context).colors.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: 1, color: CustomTheme.of(context).colors.primaryColor),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 42.toHeight,
              child: TextField(
                cursorWidth: 1,
                autofocus: true,
                controller: _textEditingController,
                onEditingComplete: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  hintText: tr('screen_language.search_lang'),
                  prefixIcon: Icon(
                    Icons.search,
                    color: CustomTheme.of(context).colors.primaryColor,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredLanguages[index],
                    style: CustomTheme.of(context).textStyles.sectionHeading1,
                  ),
                  onTap: () {
                    setState(() {
                      selectedLanguage = filteredLanguages[index];
                      selectedLocale = LocaleConstants.localeList[
                          LocaleConstants.languagesList.indexWhere(
                              (element) => element == selectedLanguage)];
                      _isExpanded = false;
                    });
                    EasyLocalization.of(context).locale = selectedLocale;
                    widget.fromAccountAction();
                    AppFirebaseAnalytics.instance
                        .logLanguageChange(setLanguage: selectedLanguage);
                  },
                );
              },
              itemCount: filteredLanguages.length,
            ),
          ],
        ),
      );
    } else {
      return buildNotExpandedState();
    }
  }

  List<String> get filteredLanguages {
    if (_textEditingController.text.isEmpty)
      return LocaleConstants.languagesList;
    return LocaleConstants.languagesList
        .where((element) => element
            .toLowerCase()
            .contains(_textEditingController.text.toLowerCase().trim()))
        .toList();
  }

  String get notExpandedStateButtonTitle {
    if (!widget.fromAccount) return tr('screen_language.choose_lang');
    final locale = EasyLocalization.of(context).locale;
    return LocaleConstants.languagesList[
        LocaleConstants.localeList.indexWhere((element) => element == locale)];
  }

  Widget buildNotExpandedState() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      child: Container(
        width: 299.toWidth,
        height: 48.toHeight,
        decoration: BoxDecoration(
          color: CustomTheme.of(context).colors.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: 2, color: CustomTheme.of(context).colors.primaryColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                notExpandedStateButtonTitle,
                style: !widget.fromAccount
                    ? CustomTheme.of(context)
                        .textStyles
                        .cardTitleFaded
                        .copyWith(fontSize: 20)
                    : CustomTheme.of(context).textStyles.sectionHeading1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: CustomTheme.of(context).colors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
