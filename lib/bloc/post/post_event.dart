part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class GetAllPastsEvent extends PostEvent {}

class AddPostEvent extends PostEvent {
  final String post;
  AddPostEvent(this.post);
}
class DeletePostEvent extends PostEvent {
  final Post post;
  DeletePostEvent(this.post);
}
class LikeOrDislikePostEvent extends PostEvent {
  final Post post;
  LikeOrDislikePostEvent(this.post);
}

class SendCommentPostEvent extends PostEvent {
  final Post post;
  final String body;
  SendCommentPostEvent(this.post,this.body);
}

class GetUserPastsEvent extends PostEvent {
  final User user;
  GetUserPastsEvent(this.user);
}
