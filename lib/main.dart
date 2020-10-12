import 'dart:async';
import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/cart/actions/cart_actions.dart';
import 'package:eSamudaay/modules/home/views/my_home.dart';
import 'package:eSamudaay/modules/login/actions/login_actions.dart';
import 'package:eSamudaay/presentations/check_user_widget.dart';
import 'package:eSamudaay/presentations/splash_screen.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/routes/routes.dart';
import 'package:eSamudaay/store.dart';
import 'package:eSamudaay/utilities/push_notification.dart';
import 'package:eSamudaay/utilities/sentry_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fm_fit/fm_fit.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  NavigateAction.setNavigatorKey(navigatorKey);
  Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    ///The return keyword below is used to abort the initialization of Sentry
    return;

    ///This is done to prevent the assertion used in setup from throwing an error
    ///HOWEVER THE ABOVE MUST BE REMOVED WHEN PUSHING TO PRODUCTION TO RECORD THE
    ///ERRORS!

    // Pass all uncaught errors from the framework to Crashlytics.
    Crashlytics.instance.recordFlutterError(details);
    if (!SentryHandler().isInProdMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded(() async {
    runApp(EasyLocalization(
      child: MyAppBase(),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ka', 'IN'),
        Locale('ml', 'IN'),
        Locale('ta', 'IN'),
        Locale.fromSubtags(languageCode: 'hi', countryCode: 'Deva-IN'),
      ],
      path: 'assets/languages',
    ));
  }, (Object error, StackTrace stackTrace) {
    // print('********************************************** ${error.toString()}');
    // print('********************************************** $stackTrace');

    /// Whenever an error occurs, call the `reportError` function. This sends
    /// Dart errors to the dev env or prod env of Sentry based on current status.
    SentryHandler().reportError(error, stackTrace);
  });
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
          store.dispatch(CheckOnBoardingStatusAction());
          store.dispatch(CheckTokenAction());
          store.dispatch(GetCartFromLocal());
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
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primarySwatch: Colors.blue,
          fontFamily: "JTLeonor",
          appBarTheme: AppBarTheme(
            color: Color(0xffffffff),
            brightness: Brightness.light,
          ),
        ),
        home: UserExceptionDialog<AppState>(
          child: MyApp(),
          onShowUserExceptionDialog: (context, excpn) {
            print('sdas');
          },
        ),
        navigatorKey: navigatorKey,
        routes: SetupRoutes.routes,
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
  }

  void navigationPageWel() {
    if (context == null) return;
    Navigator.of(context).pushReplacementNamed('/onBoarding');
  }
}
