import 'package:coinharbor/data/https.dart';
import 'package:flutter/material.dart';

const defaultPadding = 16.0;

class AppColors {
  static const darkBlue = Color(0xff011993);
  static const lightBlue = Color(0xFF94cafc);
  static const blue = Color(0xFF0000FF);
  static const cyan = Color(0xFF00FFFF);
  static const yellow = Color(0xFFFFFF00);
  static const orange = Color(0xFFFFA500);
  static const red = Color(0xFFFF0000);
  static const maroon = Color(0xFF800000);
  static const green = Color(0xFF00FF00);
  static const darkGreen = Color(0xFF006400);
  static const lemon = Color(0xFFfff700);
  static const amber = Color(0xFFFFBF00);
  static const pink = Color(0xFFFFC0CB);
  static const brightPink = Color(0xFFFC0FC0);
  static const ruby = Color(0xFFE0115F);
  static const magenta = Color(0xFFFF0090);
  static const blacks = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF808080);
  static const lightGrey = Color(0xFFD3D3D3);
  static const darkGrey = Color.fromARGB(255, 49, 48, 48);
  static const brown = Color(0xFF964B00);
  static const purple = Color(0xFF800080);
  static const gold = Color(0xFFFFD700);
  static const silver = Color(0xFFC0C0C0);
  static const acesysRed = Color(0xFF6b0402);
  static Color primarys = userServices.cache.isDarkMode
      ? const Color(0xfff58634)
      : const Color(0xfff58634);
  static Color secondary = userServices.cache.isDarkMode
      ? const Color(0xff555555)
      : const Color(0xff454545);
  static Color border = userServices.cache.isDarkMode ? grey : darkGrey;
  static Color activeBorder =
      userServices.cache.isDarkMode ? primary : acesysRed;
  static Color backgrounds = userServices.cache.isDarkMode
      ? const Color(0xff232323)
      : const Color(0xffefeded);
  static Color menuBackground = userServices.cache.isDarkMode
      ? const Color.fromARGB(255, 20, 19, 19)
      : const Color.fromARGB(255, 255, 252, 252);
  static Color text = !userServices.cache.isDarkMode
      ? const Color(0xff232323)
      : const Color(0xffefeded);
  static Color label = !userServices.cache.isDarkMode
      ? const Color(0xff292929)
      : const Color(0xffc7c5c5);
  static Color hint = !userServices.cache.isDarkMode
      ? const Color(0xff656565)
      : const Color(0xff969696);


       static const Color primary =
      Color(0xFF182A88); // lighter shade 3

  static const Color background = Color(0xfff1f1f1);

  static const Color black = Color(0xff131212);

  static const Color foundationPurpleLight = Color(0xfff4e6fd);

  static const Color foundationPurpleLightHover =
      Color(0xffeedafb);

  static const Color foundationPurpleLightActive =
      Color(0xffdcb2f8);

  static const Color foundationPurpleNormal = Color(0xff8f07e7);

  static const Color foundationPurpleNormalHover =
      Color(0xff8106d0);

  static const Color foundationPurpleNormalActive =
      Color(0xff7206b9);

  static const Color foundationPurpleDark = Color(0xff6b05ad);

  static const Color foundationPurpleDarkHover =
      Color(0xff56048b);

  static const Color foundationPurpleDarkActive =
      Color(0xff400368);

  static const Color foundationPurpleDarker = Color(0xff320251);

  static const Color foundationGreyLighter = Color(0xffa9a9a9);

  static const Color foundationGreyLightHover =
      Color(0xff989898);

  static const Color foundationGreyLightActive =
      Color(0xff838383);

  static const Color foundationGreyNormal = Color(0xff404040);

  static const Color foundationGreyNormalHover =
      Color(0xff363636);

  static const Color foundationGreyNormalActive =
      Color(0xff2f2f2f);

  static const Color foundationGreyDark = Color(0xff161616);

  static const Color foundationGreyDarkHover = Color(0xff101010);

  static const Color foundationGreyDarkActive =
      Color(0xff070707);

  static const Color foundationWhiteLight = Color(0xffffffff);

  static const Color foundationWhiteLightHover =
      Color(0xffffffff);

  static const Color foundationWhiteLightActive =
      Color(0xffffffff);

  static const Color foundationWhiteNormal = Color(0xffffffff);

  static const Color foundationWhiteNormalHover =
      Color(0xffe6e6e6);

  static const Color foundationWhiteNormalActive =
      Color(0xffcccccc);

  static const Color foundationWhiteDark = Color(0xffbfbfbf);

  static const Color foundationWhiteDarkHover =
      Color(0xff999999);

  static const Color foundationWhiteDarkActive =
      Color(0xff737373);

  static const Color foundationWhiteDarker = Color(0xff595959);
  static const Color error = Color(0xffB3261E);
}
