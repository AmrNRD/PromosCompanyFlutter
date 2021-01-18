import 'package:flutter/material.dart';

import 'user_model.dart';

class Comment {
  int id;
  String body;
  User user;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  Comment({
    @required this.id,
    @required this.body,
    @required this.user,
  });

  Comment copyWith({
    int id,
    String body,
    User user,
  }) {
    return new Comment(
      id: id ?? this.id,
      body: body ?? this.body,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'Comment{id: $id, body: $body, user: $user}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          body == other.body &&
          user == other.user);

  @override
  int get hashCode => id.hashCode ^ body.hashCode ^ user.hashCode;

  factory Comment.fromMap(Map<String, dynamic> map) {
    return new Comment(
      id: map['id'] as int,
      body: map['body'] as String,
      user: User.fromJson(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'body': this.body,
      'user': this.user,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
