 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColorManager {
  static const Color primary = Color(0xff8F47FE);
  static const Color arrowColor = Color(0xff3F88F7);
  static const Color darkPrimary = Color(0xff9D354A);
  static const Color secondaryColor = Color(0xff31252B);
  static const Color primarySold = Color(0xffD8AFB1);
  static const Color background = Color(0xffF5F6FA);
  static const Color lightPrimary = const Color(0xffFAEDEF);
  static const Color greyLightHover = Color(0xffEFF1F3);
  static const Color greySold = Color(0xffDEE2E7);
  static const Color greenLight = Color(0xffE6FAEE);
  static const Color shadowColor = Color(0x19000000);

  static const Color redColor = Color(0xffFF0000);
  static const Color redLight = Color(0xffFFE6E6);

  //this change opcity with 80% look this link https://gist.github.com/lopspower/03fb1cc0ac9f32ef38f4
  static Color darkGrey = const Color(0xffdddbdd);
  static Color dark = const Color(0xff8E98A8);
  static const Color editColor = Color(0xff006FDE);

  static const Color grey = Color(0xff737477);
  static Color green = Color.fromARGB(255, 41, 160, 36);
  static const Color lightGrey = Color(0xffd6d6d6);
  static const Color coolGray = Color(0xff93A3B0);
  static Color pinCodeColor = const Color(0xffefeff3);
  static const Color gray80 = Color.fromRGBO(147, 163, 176, 0.8);
  static const Color gray16 = Color.fromRGBO(147, 163, 176, 0.16);

  // static const Color danger = Color(0xffe61f43);
  static const Color danger = Color(0xffFF0000);
  static const Color error = Color(0xffA33030);
  static const Color error50 = Color(0xffFCECEC);

  //ORDER TIME STATUS
  static const Color delayed = Color(0xffE54343);
  static const Color onTime = Color(0xff43B585);
  static const Color almostDelayed = Color(0xffF5C543);

  //Order Status Colors
  static const Color cancelled = Color(0xffe61f43);
  static const Color newlyPlaced = Color(0xff6141AC);
  static const Color inKitchen = Color(0xff1358D0);
  static const Color newOrder = Color(0xff19A325);

  //Button status colors
  static const Color warning = Color(0xffF5C543);
  static const Color missing = Color(0xffFFC559);
  static const Color reserved = Color(0xff007BC2);
  static const Color paid = Color(0xffFFC559);
  static const Color available = Color(0xff41C19F);
  static const Color info = Color(0xff006FDE);
  static const Color success = Color(0xff43B585);
  static const Color successDark = Color(0xff30815E);
  static const Color successLight = Color(0xffECF8F3);
  static const Color white = Color(0xffFFFFFF);
  static Color dimWhite = const Color(0xffF5F6FA);
  static const Color black = const Color(0xff000000);

  //App Bar titles and screen main titles
  static const Color textHeaderColor = Color(0xff1E1E1E);

  //Regular text color
  static const Color textColor = Color(0xff3A3A38);
  static const Color anotherTextColor = Color(0xff33393E);
  static const Color textSubTitleColor = Color(0xffa3a3a3);
  static const Color neutralGray900 = Color(0xff3A3A38);
  static const Color neutralGray700 = Color(0xff63625F);
  static const Color neutralGray100 = Color(0xffDBDBD9);
  static const Color neutralGray50 = Color(0xffF3F3F3);

  //temp gradient color
  static LinearGradient cardGradient1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      ColorManager.darkPrimary,
      ColorManager.darkPrimary,
      ColorManager.primary,
    ],
  );
}
