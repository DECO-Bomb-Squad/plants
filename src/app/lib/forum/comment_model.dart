import 'dart:convert';

import 'package:app/base/user.dart';
import 'package:app/forum/test_comments.dart';

/*
 * -- Comment Manager --
 * Acts as a single access point for managing comments.
 * Specifically, given a post ID will make API requests,
 * assemble the comment trees, render them out,
 * and then return a Column containing the comments
 */
class CommentManagerModel {
  int postID;
  List<CommentModel> comments;

  CommentManagerModel(this.postID)
      : comments = [];
}

class CommentModel {
  int commentID;        // Comment ID
  int authorID;         // UserID of author
  int score;            // Point score
  String content;       // Actual comment text
  DateTime created;     // When the comment was posted

  User author;                // User object
  List<CommentModel> replies; // Replies to comment

  CommentModel.fromJSON(Map<String, dynamic> json)
      : commentID = json['commentID'],
        authorID = json['author'],
        score = json['score'],
        content = json['content'],
        created = DateTime.parse(json["created"]),
        author = User.fromJSON(jsonDecode('{"id": 1, "name": "Test"}')),
        replies = [];
  
  String getReadableTimeAgo() {
    Duration delta = DateTime.now().difference(created);
    if (delta.inMinutes < 60) {
      return "${delta.inMinutes} minutes";
    } else if (delta.inHours < 24) {
      return "${delta.inHours} hours";
    } else {
      return "${delta.inDays} days";
    }
  }
}