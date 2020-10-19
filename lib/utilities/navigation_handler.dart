import 'package:flutter/material.dart';

class NavigationHandler {
  NavigationHandler._();
  static NavigationHandler _instance = NavigationHandler._();
  factory NavigationHandler() => _instance;

  final navigatorKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = _MyRouteObserver();

  List<String> navigationStack = [];
}

class _MyRouteObserver extends RouteObserver<PageRoute> {
  @override
  void didPush(Route route, Route previousRoute) {
    debugPrint('--------------------------- did push ${route.settings.name}');
    NavigationHandler().navigationStack.add(route.settings.name);
    debugPrint(
        '--------------------------- ${NavigationHandler().navigationStack}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    debugPrint('--------------------------- did pop ${route.settings.name}');
    NavigationHandler().navigationStack.removeLast();
    debugPrint(
        '--------------------------- ${NavigationHandler().navigationStack}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    debugPrint(
        '--------------------------- did replace ${newRoute.settings.name}');
    NavigationHandler().navigationStack.removeLast();
    NavigationHandler().navigationStack.add(newRoute.settings.name);
    debugPrint(
        '--------------------------- ${NavigationHandler().navigationStack}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    debugPrint('--------------------------- did remove ${route.settings.name}');
    NavigationHandler().navigationStack.removeLast();
    debugPrint(
        '--------------------------- ${NavigationHandler().navigationStack}');
    super.didRemove(route, previousRoute);
  }
}
