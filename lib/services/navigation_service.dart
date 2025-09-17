/* import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'locator.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();
  BuildContext? materialC;

  navigateTo(String routeName, {dynamic argument}) {
    return materialC!.go(routeName, extra: argument);
  }

  Future<dynamic> navigateToReplace(String routeName, {dynamic argument}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argument);
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {dynamic argument}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> pushToAndRemoveUntil(routeObject, {dynamic argument}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => routeObject), (route) => false);
  }

  Future<dynamic> push(routeObject, {dynamic argument}) {
    return navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => routeObject));
  }

  Future<dynamic> pushAndReplace(routeObject, {dynamic argument}) {
    return navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(builder: (context) => routeObject));
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void goBackWithResult(result) {
    return navigatorKey.currentState!.pop(result);
  }
}
 */