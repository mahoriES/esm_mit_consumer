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
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint('--------------------------- did push ${route.settings.name}');
      NavigationHandler().navigationStack.add(route.settings.name);
      debugPrint(
          '--------------------------- ${NavigationHandler().navigationStack}');
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint('--------------------------- did pop ${route.settings.name}');
      if (NavigationHandler().navigationStack.isNotEmpty) {
        NavigationHandler().navigationStack.removeLast();
      }
      debugPrint(
          '--------------------------- ${NavigationHandler().navigationStack}');
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    if (newRoute is PageRoute && oldRoute is PageRoute) {
      debugPrint(
          '--------------------------- did replace ${newRoute.settings.name}');
      if (NavigationHandler().navigationStack.isNotEmpty) {
        NavigationHandler().navigationStack.removeLast();
      }
      NavigationHandler().navigationStack.add(newRoute.settings.name);
      debugPrint(
          '--------------------------- ${NavigationHandler().navigationStack}');
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint(
          '--------------------------- did remove ${route.settings.name}');
      if (NavigationHandler().navigationStack.isNotEmpty) {
        NavigationHandler().navigationStack.removeLast();
      }
      debugPrint(
          '--------------------------- ${NavigationHandler().navigationStack}');
    }
    super.didRemove(route, previousRoute);
  }
}
