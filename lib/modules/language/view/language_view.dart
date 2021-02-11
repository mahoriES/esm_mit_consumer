import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/image_path_constants.dart';
import 'package:eSamudaay/utilities/firebase_analytics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/utilities/size_config.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromAccount = false;

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    if (arguments != null) print("from_account ${arguments['fromAccount']}");
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return Scaffold(
              body: SafeArea(
                child: SizedBox(
                  height: SizeConfig.screenHeight,
                  child: Stack(
                    children: [
                      Image.asset(
                        ImagePathConstants.languageSelectionBackdrop,
                        height: 496.toHeight,
                        width: SizeConfig.screenWidth,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        right: 38.toWidth,
                        top: 53.toHeight,
                        child: Text(
                          "Choose\nyour Language",
                          textAlign: TextAlign.end,
                          style: CustomTheme.of(context)
                              .textStyles
                              .topTileTitle
                              .copyWith(
                                  color: CustomTheme.of(context)
                                      .colors
                                      .primaryColor,
                                  fontSize: 30),
                        ),
                      ),
                      if ((arguments != null
                          ? arguments['fromAccount'] ?? false
                          : false))
                        Positioned(
                          left: 25.toWidth,
                          top: 35.toHeight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              color: CustomTheme.of(context)
                                  .colors
                                  .backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: CustomTheme.of(context)
                                        .colors
                                        .primaryColor,
                                  ),
                                  Text(
                                    'Back',
                                    style: CustomTheme.of(context)
                                        .textStyles
                                        .sectionHeading1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 100),
                          padding: EdgeInsets.only(
                            top: 476.toHeight - 48.toHeight - bottomInsets,
                          ),
                          child: DropDown(
                            fromAccountAction: () {
                              snapshot.navigateToPhoneNumberPage(
                                  arguments != null
                                      ? arguments['fromAccount'] ?? false
                                      : false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();

  Function(bool fromAccount) navigateToPhoneNumberPage;

  _ViewModel.build({
    this.navigateToPhoneNumberPage,
  }) : super(equals: []);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      navigateToPhoneNumberPage: (value) {
        value
            ? dispatch(NavigateAction.pop())
            : dispatch(NavigateAction.pushNamed(RouteNames.LANDING_PAGE));
      },
    );
  }
}

class DropDown extends StatefulWidget {
  final Function fromAccountAction;

  const DropDown({Key key, @required this.fromAccountAction}) : super(key: key);

  static List<String> get languagesList {
    return <String>[
      "English",
      "Hindi (हिन्दी)",
      "Kannada (ಕನ್ನಡ)",
      "Tamil (தமிழ்)",
      "Telugu (తెలుగు)",
    ];
  }

  static List<Locale> get localeList {
    return <Locale>[
      Locale('en', 'US'),
      Locale.fromSubtags(languageCode: 'hi', countryCode: 'Deva-IN'),
      Locale('ka', 'IN'),
      Locale('ta', 'IN'),
      Locale('te', 'IN'),
    ];
  }

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
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
                  hintText: 'Search for language',
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
                      selectedLocale = DropDown.localeList[
                          DropDown.languagesList.indexWhere(
                              (element) => element == selectedLanguage)];
                      _isExpanded = false;
                    });
                    EasyLocalization.of(context).locale = selectedLocale;
                    widget.fromAccountAction();
                    AppFirebaseAnalytics.instance.logLanguageChange(setLanguage: selectedLanguage);
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
    if (_textEditingController.text.isEmpty) return DropDown.languagesList;
    return DropDown.languagesList
        .where((element) => element
            .toLowerCase()
            .contains(_textEditingController.text.toLowerCase().trim()))
        .toList();
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
                selectedLanguage == null ? 'Choose Language' : selectedLanguage,
                style: selectedLanguage == null
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