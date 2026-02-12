import 'dart:ui';
import 'package:get/get.dart';

class ColorConst {

  bool get _isDark => Get.isDarkMode;

  /// Primary brand color - stays same in both themes
  Color get colorPrimary => Color(0xffffcc00);

  /// Secondary brand color - slightly brighter in dark mode for visibility
  Color get secondColorPrimary => _isDark ? Color(0xff4a8fe7) : Color(0xff01329b);

  /// White in light mode, dark surface in dark mode (used for backgrounds/cards)
  Color get whiteColor => _isDark ? Color(0xff1c1c2e) : Color(0xffffffff);

  /// Gray fill color - darker in dark mode
  Color get gryColor => _isDark ? Color(0xff2a2a3e) : Color(0xfff0f3f6);

  /// Dark gray text - lighter in dark mode for readability
  Color get darkGryColor => _isDark ? Color(0xffb0b0b0) : Color(0xff575050);

  /// Dark blue - adjusted for dark mode
  Color get darkBlueColor => _isDark ? Color(0xff2a3a5e) : Color(0xff232f3e);

  /// Black text - becomes white in dark mode
  Color get blackColor => _isDark ? Color(0xffe0e0e0) : Color(0xff000000);

  /// Light gray background - darker in dark mode
  Color get gryLightColor => _isDark ? Color(0xff252538) : Color(0xfff6f5f5);

  /// Red accent - stays same, slightly adjusted for dark mode visibility
  Color get redColor => _isDark ? Color(0xffff4444) : Color(0xffe32526);

  /// Green accent - stays same
  Color get greenColor => Color(0xff3eed0e);

  /// Dark green - stays same
  Color get dark_greenColor => Color(0xff379c40);

  /// Scaffold background
  Color get scaffoldBgColor => _isDark ? Color(0xff121220) : Color(0xffffffff);

  /// Card background
  Color get cardBgColor => _isDark ? Color(0xff1c1c2e) : Color(0xffffffff);

  /// Divider color
  Color get dividerColor => _isDark ? Color(0xff3a3a4e) : Color(0xffe0e0e0);

  /// AppBar background - same as scaffold
  Color get appBarBgColor => scaffoldBgColor;

  /// Bottom nav background
  Color get bottomNavBgColor => _isDark ? Color(0xff1c1c2e) : Color(0xffffffff);

  /// Dialog background
  Color get dialogBgColor => _isDark ? Color(0xff252538) : Color(0xffffffff);

  /// Chat bubble (admin) color
  Color get chatAdminBubbleColor => _isDark ? Color(0xff2a2a3e) : Color(0xffe0e0e0);

  /// Chat text (admin) color
  Color get chatAdminTextColor => _isDark ? Color(0xffe0e0e0) : Color(0xff1a1a1a);
}
