part of 'user_bloc.dart';

abstract class UserEvent {
  UserEvent();
}
class GetUser extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final User user;
  UpdateUserProfile(this.user);
}

class UpdateUserProfilePicture extends UserEvent {
  final String photo;
  final String name;
  UpdateUserProfilePicture(this.photo, this.name);
}

class UserReportPurchase extends UserEvent {
  final int id;
  final String purchaseToken;
  final String transactionReceipt;
  final String productId;
  UserReportPurchase(this.id, this.purchaseToken, this.transactionReceipt, this.productId);

}

class LoginUser extends UserEvent {
  final String email;
  final String password;
  final String firebaseToken;
  final String platform;
  LoginUser(this.email,this.password,this.firebaseToken,this.platform);

}

class LoginUserWithProvider extends UserEvent {
  final String providerType;
  final String userID;
  final String email;
  final String token;
  final String name;
  final String profileUrl;
  final String platform;

  LoginUserWithProvider(this.providerType,this.userID,this.email,this.name,this.token,this.profileUrl,this.platform);

}

class SignUpUser extends UserEvent {
  final String email;
  final String name;
  final String mobile;
  final String city;
  final String gender;
  final double lat;
  final double long;
  final String avatar;
  final String password;
  final String passwordConfirmation;
  final String platform;
  final String firebaseToken;
  SignUpUser({@required this.email, @required this.name, @required this.mobile, @required this.city, @required this.gender, @required this.lat, @required this.long, @required this.avatar, @required this.password, @required this.passwordConfirmation, @required this.platform,this.firebaseToken});

}


class ForgotPassword extends UserEvent {
  final String email;
  ForgotPassword(this.email);
}


class FindResetPassword extends UserEvent {
  final String token;
  FindResetPassword(this.token);
}

class ResetPassword extends UserEvent {
  final String email;
  final String token;
  final String newPassword;
  ResetPassword(this.email,this.token,this.newPassword);
}

class VerifiedLogin extends UserEvent {}


class LogoutUser extends UserEvent {}

