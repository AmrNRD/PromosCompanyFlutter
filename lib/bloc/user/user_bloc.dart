import 'dart:async';

import 'package:PromoMeCompany/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(null);

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is GetUser) {
        yield UserLoading();
        final User user = await userRepository.fetchUserData();
        yield UserLoaded(user);
      }else if(event is VerifiedLogin){
        yield UserLoading();
        await userRepository.loginVerified();
        yield VerifiedSuccessfully();
      } else if (event is LoginUser) {
        yield UserLoading();
        final User user = await userRepository.login(event.email, event.password, event.platform, event.firebaseToken);
        yield UserLoaded(user);
      }else if (event is UpdateUserProfile) {
        yield UserLoading();
        final User user = await userRepository.update(event.user);
        yield UserLoaded(user);
      } else if (event is UpdateUserProfilePicture) {
        yield UserProfilePictureLoading();
        final User user = await userRepository.updateProfilePicture(event.photo,event.name);
        yield UserProfilePictureLoaded(user);
      } else if (event is SignUpUser) {
        yield UserLoading();
        final User user = await userRepository.signUp(event.name, event.email, event.password, event.platform, event.firebaseToken, event.mobile, event.city, event.gender, event.lat, event.long, event.avatar,event.photoName,event.address);
        yield UserLoaded(user);
      }else if (event is LogoutUser) {
        yield UserLoading();
        Root.user = await userRepository.logout();
        yield UserLoggedOut();
      }
    } catch (error) {
      debugPrint("Error happened in UserBloc of type ${error.runtimeType} with output ' ${error.toString()} '");
      yield UserError(error.toString());
    }
  }
}
