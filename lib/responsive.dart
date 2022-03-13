import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1199;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static bool isBigDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1500;

  static bool isSuperBigDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 2000;

  //If is true then user in on mobile app if false user is in browser
  static bool isMobileOs(BuildContext context) =>
      !kIsWeb ;
}
