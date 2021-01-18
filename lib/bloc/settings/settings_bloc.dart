import 'dart:async';

import '../../data/repositories/settings_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.settingsRepository) : super(SettingsInitial());
  final SettingsRepository settingsRepository;
  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    try {
      print(event.runtimeType);
      if (event is LoadSettings) {
        ThemeMode themeMode=await settingsRepository.getThemeData();
        Locale locale=await settingsRepository.getLocal();
        yield SettingsLoaded(themeMode,locale);
      } else if (event is ChangeTheme) {
        ThemeMode themeMode=await settingsRepository.changeThemeData(event.themeMode);
        yield ThemeModeLoaded(themeMode);
      } else if (event is ChangeLocal) {
        Locale locale=await settingsRepository.changeLocalData(event.locale);
        yield LocalLoaded(locale);
      }
    } catch (error) {
      debugPrint("Error happened in SettingsBloc of type ${error.runtimeType} with output ' ${error.toString()} '");
      try{
        ThemeMode themeMode=await settingsRepository.getThemeData();
        Locale locale=await settingsRepository.getLocal();
        yield SettingsLoaded(themeMode,locale);
      }catch(error){
        yield SettingsLoaded(ThemeMode.system,Locale('en'));
      }
    }
  }
}
