
import 'comment_model.dart';
import 'user_model.dart';

class Post {
  int id;
  String content;
  String image;
  User user;
  DateTime lastUpdate;
  int commentsCount;
  int likesCount;
  bool likedByMe;
  List<Comment>comments;
  Post({this.id, this.content, this.image, this.user,this.lastUpdate,this.likesCount=0,this.commentsCount=0,this.likedByMe=false,this.comments});

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a Post object
      id: data['id'],
      content: data['content'],
      image: data['image'],
      user: User.fromJson(data['user']),
      lastUpdate: DateTime.tryParse(data['last_update'].toString()),
      commentsCount: int.tryParse(data['comment_count'].toString())??0,
      likesCount: int.tryParse(data['like_count'].toString())??0,
      likedByMe:data['liked_by_me']??false,
      comments:  List<Comment>.from((data['comments'] as List).map((e) => Comment.fromMap(e)).toList())
    );
  }

}
