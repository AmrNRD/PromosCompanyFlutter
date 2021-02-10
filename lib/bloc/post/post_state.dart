part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final Post post;
  PostLoaded(this.post);
}
class PostDeleted extends PostState {}

class PostsLoaded extends PostState {
  final List<Post>posts;
  PostsLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
