import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  /// Follows system theme by default
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  /// Check if current theme is dark
  bool get isDarkMode => Get.isDarkMode;

  /// Toggle between light and dark manually (optional, if needed later)
  void toggleTheme() {
    if (Get.isDarkMode) {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  /// Set theme to follow system
  void setSystemTheme() {
    themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
  }
}
