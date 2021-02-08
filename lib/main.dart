import 'dart:async';
import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:eSamudaay/modules/home/views/my_home.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/presentations/check_user_widget.dart';
import 'package:eSamudaay/presentations/splash_screen.dart';
import 'package:eSamudaay/redux/actions/general_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/URLs.dart';
import 'package:eSamudaay/utilities/user_manager.dart';
import 'package:esamudaay_app_update/app_update_service.dart';
import 'package:eSamudaay/utilities/navigation_handler.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:esamudaay_themes/esamudaay_themes.dart' as themesPackage;

// Toggle this for testing Crashlytics in the app locally, regardless of the server type or app build mode.
final _kTestingCrashlytics = true;

void main() async {
  NavigateAction.setNavigatorKey(NavigationHandler.navigatorKey);
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFlutterFire();

  //pass 'isTesting : true' here to get isUpdateAvailable = true for testing purpose.
  await AppUpdateService.checkAppUpdateAvailability();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = (FlutterErrorDetails details) {
    // Pass all uncaught errors from the framework to Crashlytics.
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  runZonedGuarded(() async {
    runApp(EasyLocalization(
      child: MyAppBase(),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ka', 'IN'),
        // Locale('ml', 'IN'),
        Locale('te', 'IN'),
        Locale('ta', 'IN'),
        Locale.fromSubtags(languageCode: 'hi', countryCode: 'Deva-IN'),
      ],
      path: 'assets/languages',
    ));
  }, (error, stackTrace) {
    debugPrint('runZonedGuarded: Caught Error -> $error in root zone.');
    debugPrint('Stacktrace -> $stackTrace');

    /// Whenever an error occurs, call the `recordError` function. This sends
    /// it submits a Crashlytics report of a caught error.
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

// Define an async function to initialize FlutterFire
Future<void> _initializeFlutterFire() async {
  // Wait for Firebase to initialize
  await Firebase.initializeApp();

  if (_kTestingCrashlytics) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Else only enable it in non-debug builds.
    //Could additionally extend this to allow users to opt-in or something else.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(ApiURL.baseURL == ApiURL.liveURL);
  }

  // Pass all uncaught errors to Crashlytics.
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // Forward details of this error to original handler.
    originalOnError(errorDetails);
  };
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    PushNotificationsManager().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit.init(width: MediaQuery.of(context).size.width);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) {
          store.dispatch(SetCurrentCircleFromPrefsAction());
          store.dispatch(CheckOnBoardingStatusAction());
          store.dispatch(CheckTokenAction());
          store.dispatch(GetUserFromLocalStorageAction());
        },
        builder: (context, snapshot) {
          return CustomSplashScreen(
            errorSplash: errorSplash(),
            backgroundColor: Colors.white,
            loadingSplash: null,
            seconds: 0,
            home: CheckUser(builder: (context, snapshot) {
              return snapshot ? MyHomeView() : SplashScreen();
            }),
          );
        });
  }

  Widget errorSplash() {
    return Center(
      child: Text(
        "ERROR",
        style: TextStyle(fontSize: 25.0, color: Colors.red),
      ),
    );
  }

  Widget loadingSplash() {
    return Container(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.asset('assets/images/splash.png'),
      )),
    );
  }
}

class MyAppBase extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      // wrapping material app with CustomTheme inherited widget to access themeData.
      child: themesPackage.EsamudaayTheme(
        initialThemeType: themesPackage.THEME_TYPES.CONSUMER_APP_PRIMARY_THEME,
        child: CustomTheme(
          // For now defining the initial theme as LIGHT .
          // Later it should be used from local database as per user's preference.
          initialThemeType: THEME_TYPES.LIGHT,
          child: MaterialApp(
            builder: (context, child) {
              SizeConfig().init(context);

              return Theme(
                data: CustomTheme.of(context).themeData,
                child: child,
              );
            },
            navigatorObservers: [NavigationHandler.routeObserver],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              EasyLocalization.of(context).delegate,
            ],
            supportedLocales: EasyLocalization.of(context).supportedLocales,
            locale: EasyLocalization.of(context).locale,
            debugShowCheckedModeBanner: false,
            home: UserExceptionDialog<AppState>(
              child: MyApp(),
              onShowUserExceptionDialog: (context, excpn) {
                print('sdas');
              },
            ),
            navigatorKey: NavigationHandler.navigatorKey,
            routes: SetupRoutes.routes,
          ),
        ),
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function getAddressAndLoginStatus;

  _ViewModel();

  _ViewModel.build({this.getAddressAndLoginStatus});

  @override
  BaseModel fromStore() {
    return _ViewModel.build(getAddressAndLoginStatus: () {});
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time

      return new Timer(_duration, navigationPageWel);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.asset('assets/images/splash.png'),
      )),
    );
  }

  void navigationPageHome() {
    if (context == null) return;
    Navigator.of(context).pushReplacementNamed('/loginView');
    // If launch screen is login , then show app_update prompt here.
    store.dispatch(CheckAppUpdateAction(context));
  }

  void navigationPageWel() async {
    if (context == null) return;
    //Navigator.of(context).pushReplacementNamed('/onBoarding');
    await UserManager.saveSkipStatus(status: true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
    store.dispatch(
        NavigateAction.pushNamedAndRemoveAll('/language'));
    // If launch screen is onboarding , then show app_update prompt here.
    store.dispatch(CheckAppUpdateAction(context));
  }
}
