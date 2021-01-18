
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository{
  Future<ThemeMode> getThemeData();
  Future<Locale> getLocal();
  Future<ThemeMode> changeThemeData(ThemeMode themeMode);
  Future<Locale> changeLocalData(Locale locale);
}

class SettingsDataRepository extends SettingsRepository{
  @override
  Future<Locale> changeLocalData(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', locale.languageCode);
   return locale;
  }

  @override
  Future<ThemeMode> changeThemeData(ThemeMode themeMode) async {
    String theme;
    switch (themeMode) {
      case ThemeMode.light:
        theme="Light";
        break;
      case ThemeMode.dark:
        theme="Dark";
        break;
      case ThemeMode.system:
        theme="System";
        break;
      default:
        theme="System";
        break;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
    return themeMode;
  }

  @override
  Future<Locale> getLocal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('languageCode') == null) {
      sharedPreferences.setString('languageCode', "ar");
      return Locale('ar');
    }
    return Locale(sharedPreferences.getString('languageCode'));
  }

  @override
  Future<ThemeMode> getThemeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("theme")) {
      String theme = sharedPreferences.getString("theme");
      switch (theme) {
        case "Light":
          return ThemeMode.light;
        case "Dark":
          return ThemeMode.dark;
        case "System":
          return ThemeMode.system;
      }
    }
    return ThemeMode.system;
  }


}