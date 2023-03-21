
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_sp_util.dart';

class Themetool{

/// 切换主题
  static changeTheme({int? type = 1}) {
    ThemeMode mode = getlocalprofileaboutThemeModel();
    ThemeData themeData = getlocalprofileaboutThemeData();
    Get.changeThemeMode(mode);
    Get.changeTheme(themeData);
    updateTheme();
  }
  static updateTheme() {
    Future.delayed(const Duration(milliseconds: 250), () {
      Get.forceAppUpdate();
    });
  }
/// 获取本地 主题配置
  static getlocalprofileaboutThemeModel() {
    int theme = CommonSpUtil.getThemeType();
    ThemeMode themeMode = ThemeMode.light;
    if (theme == 0) {
      themeMode = ThemeMode.light;
    } else if (theme == 1) {
      themeMode = ThemeMode.dark;
    } else if (theme == 2) {
      themeMode = ThemeMode.system;
    }
    return themeMode;
  }

    static getlocalprofileaboutThemeData() {
    int theme = CommonSpUtil.getThemeType();
    ThemeData themeData = ThemeData.light();
    if (theme == 0) {
      themeData = ThemeData(brightness: Brightness.light);
    } else if (theme == 1) {
      themeData = ThemeData(brightness: Brightness.dark);
    } else if (theme == 2) {
      if (!Get.isDarkMode) {
        themeData = ThemeData(brightness: Brightness.dark);
      } else {
        themeData = ThemeData(brightness: Brightness.light);
      }
    }
    return themeData;
  }
}