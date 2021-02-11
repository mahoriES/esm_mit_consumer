import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


/// Signature for a function that extracts a screen name from [RouteSettings].
///
/// Usually, the route name is not a plain string, and it may contains some
/// unique ids that makes it difficult to aggregate over them in Firebase
/// Analytics.
typedef String ScreenNameExtractor(RouteSettings settings);

String defaultNameExtractor(RouteSettings settings) => settings.name;

/// A [NavigatorObserver] that sends events to Firebase Analytics when the
/// currently active [PageRoute] changes.
///
/// When a route is pushed or popped, [nameExtractor] is used to extract a name
/// from [RouteSettings] of the now active route and that name is sent to
/// Firebase.
class FirebaseAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  /// Creates a [NavigatorObserver] that sends events to [FirebaseAnalytics].
  ///
  /// When a route is pushed or popped, [nameExtractor] is used to extract a
  /// name from [RouteSettings] of the now active route and that name is sent to
  /// Firebase. Defaults to `defaultNameExtractor`.
  ///
  /// If a [PlatformException] is thrown while the observer attempts to send the
  /// active route to [analytics], `onError` will be called with the
  /// exception. If `onError` is omitted, the exception will be printed using
  /// `debugPrint()`.
  FirebaseAnalyticsObserver({
    @required this.analytics,
    this.nameExtractor = defaultNameExtractor,
    Function(PlatformException error) onError,
  }) : _onError = onError;

  final FirebaseAnalytics analytics;
  final ScreenNameExtractor nameExtractor;
  final void Function(PlatformException error) _onError;

  void _sendScreenView(PageRoute<dynamic> route) {
    final String screenName = nameExtractor(route.settings);
    if (screenName != null) {
      analytics.setCurrentScreen(screenName: screenName).catchError(
            (Object error) {
          if (_onError == null) {
            debugPrint('$FirebaseAnalyticsObserver: $error');
          } else {
            _onError(error);
          }
        },
        test: (Object error) => error is PlatformException,
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}