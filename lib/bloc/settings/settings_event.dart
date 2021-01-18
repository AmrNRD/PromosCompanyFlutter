part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}


class LoadSettings extends SettingsEvent {}

class ChangeTheme extends SettingsEvent {
  final ThemeMode themeMode;
  ChangeTheme(this.themeMode);
}
class ChangeLocal extends SettingsEvent {
  final Locale locale;
  ChangeLocal(this.locale);
}