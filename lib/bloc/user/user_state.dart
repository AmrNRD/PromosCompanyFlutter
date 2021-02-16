part of 'user_bloc.dart';

abstract class UserState {
   UserState();
}

class UserInitial extends UserState {
   UserInitial();
}

class UserLoading extends UserState {
   UserLoading();

}
class UserProfilePictureLoading extends UserState {
  UserProfilePictureLoading();
}

class UserLoaded extends UserState {
  final User user;
   UserLoaded(this.user);
}
class UserProfilePictureLoaded extends UserState {
  final User user;
  UserProfilePictureLoaded(this.user);
}
class UserSignedUp extends UserState {
  final User user;
  UserSignedUp(this.user);
}
class UserError extends UserState {
  final String message;
   UserError(this.message);
}
class UserMessage extends UserState {
  final String message;
   UserMessage(this.message);

}

class VerifiedSuccessfully extends UserState {
  VerifiedSuccessfully();
}


class UserLoggedOut extends UserState {
  UserLoggedOut();
}