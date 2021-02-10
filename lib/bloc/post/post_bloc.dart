import 'dart:async';

import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/post_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';

part 'post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(this.postRepository) : super(PostInitial());
  final PostRepository postRepository;

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    try {
      if (event is GetAllPastsEvent) {
        yield PostLoading();
        List<Post>posts=await postRepository.getAllPosts();
        yield PostsLoaded(posts);
      }else if (event is LikeOrDislikePostEvent) {
        Post updatedPost=await postRepository.likeOrDislikePost(event.post);
        yield PostLoaded(updatedPost);
      }else if (event is SendCommentPostEvent) {
        Post updatedPost=await postRepository.commentPost(event.post, event.body);
        yield PostLoaded(updatedPost);
      }else if (event is AddPostEvent) {
        Post updatedPost=await postRepository.addPost(event.post);
        yield PostLoaded(updatedPost);
      }else if (event is DeletePostEvent) {
        await postRepository.deletePost(event.post);
        yield PostDeleted();
      }
    } catch (error) {
      yield PostError(error.toString());
    }
  }
}
