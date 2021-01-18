part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  SettingsLoaded(this.themeMode, this.locale);
}

class LocalLoaded extends SettingsState {
  final Locale locale;
  LocalLoaded(this.locale);
}

class ThemeModeLoaded extends SettingsState {
  final ThemeMode themeMode;
  ThemeModeLoaded(this.themeMode);
}
