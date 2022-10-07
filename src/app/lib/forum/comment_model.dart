import 'dart:convert';

import 'package:app/base/user.dart';
import 'package:app/forum/test_comments.dart';
import 'package:app/screens/plant_care_screen.dart';
import 'package:flutter/material.dart';

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
  bool plantCareModel;
  String content;       // Actual comment text
  DateTime created;     // When the comment was posted

  //User author;                // User object
  List<CommentModel> replies; // Replies to comment

  CommentModel.fromJSON(Map<String, dynamic> json)
      : commentID = json['comment_id'],
        authorID = json['author_id'],
        score = json['score'],
        content = json['content'],
        created = DateTime.parse(json["created"]),
        replies = [],
        plantCareModel = false

        {
          if (json.containsKey("replies")) {
            replies = (json["replies"] as List<dynamic>).map((e) => CommentModel.fromJSON(e)).toList();
          }
        }
        //author = User.fromJSON(jsonDecode('{"id": 1, "name": "Test"}')),
        
  
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