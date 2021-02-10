import 'dart:convert';

import 'package:PromoMeCompany/data/models/comment_model.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';

import '../../main.dart';
import '../models/user_model.dart';
import '../sources/remote/base/api_caller.dart';
import '../sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostRepository {
  Future<List<Post>> getAllPosts();
  Future<Post> likeOrDislikePost(Post post);
  Future<Post> addPost(String post);
  Future<Post> commentPost(Post post,String body);
  Future<Post> updateCommentPost(Post post,Comment comment);
  Future<Post> deleteCommentPost(Post post,Comment comment);
  Future deletePost(Post post);
}

class PostDataRepository implements PostRepository {
  @override
  Future<List<Post>> getAllPosts() async {
    final responseData =
        await APICaller.getData("/my-posts", authorizedHeader: true);
    List<Post> posts = [];
    for (var postData in responseData['data']) {
      posts.add(Post.fromJson(postData));
    }
    return posts;
  }

  @override
  Future<List<Post>> profilePosts(User user) async {
    final responseData = await APICaller.getData("/company-posts/"+user.id.toString(),authorizedHeader: true);
    List<Post> posts = [];
    for (var postData in responseData['data']) {
      posts.add(Post.fromJson(postData));
    }
    return posts;
  }

  @override
  Future<Post> likeOrDislikePost(Post post) async {
    final responseData = await APICaller.postData("/post/"+post.id.toString()+"/like",authorizedHeader: true);
    Post updatedPost=Post.fromJson(responseData['data']);
    return updatedPost;
  }

  @override
  Future<Post> commentPost(Post post, String body) async {
    final responseData = await APICaller.postData("/post/"+post.id.toString()+"/store-comment",body: {"body":body},authorizedHeader: true);
    Post updatedPost=Post.fromJson(responseData['data']);
    return updatedPost;
  }

  @override
  Future<Post> deleteCommentPost(Post post, Comment comment) {
    // TODO: implement deleteCommentPost
    throw UnimplementedError();
  }

  @override
  Future<Post> updateCommentPost(Post post, Comment comment) async {
    final responseData = await APICaller.putData("/post/"+post.id.toString()+"/update-comment/"+comment.id.toString(),body: {"body":comment.body},authorizedHeader: true);
    Post updatedPost=Post.fromJson(responseData['data']);
    return updatedPost;
  }

  @override
  Future<Post> addPost(String post) async {
    final responseData = await APICaller.postData("/posts",body: {"content":post},authorizedHeader: true);
    Post updatedPost=Post.fromJson(responseData['data']);
    return updatedPost;
  }

  @override
  Future deletePost(Post post) async {
    final responseData = await APICaller.deleteData("/posts/"+post.id.toString(),authorizedHeader: true);
    return true;
  }


}
