import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppImages {
  static const lightLogo = "assets/images/app_logo.png";
  static const darkLogo = "assets/images/app_logo_light.png";
  static const lightLogoSplash = "assets/images/app_logo_splash.png";
  static const darkLogoSplash = "assets/images/app_logo_splash_light.png";

  static String getAppLogo(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightLogo
        : darkLogo;
  }

  static String getAppLogoSplash(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightLogoSplash
        : darkLogoSplash;
  }
}
