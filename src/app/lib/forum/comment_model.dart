
import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';

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

  CommentManagerModel(this.postID) : comments = [];
}

class CommentModel {
  int commentID;        // Comment ID
  int authorID;         // UserID of author
  int? parentID;
  int score;            // Point score
  String username;
  EditPlantCareProfileModel? plantCareModel;  // Plant care model if attached
  String content;       // Actual comment text
  DateTime created;     // When the comment was posted

  //User author;                // User object
  List<CommentModel> replies; // Replies to comment

  CommentModel.fromJSON(Map<String, dynamic> json)
      : commentID = json['id'],
        parentID = json['parentId'],
        authorID = json['userId'],
        score = json['score'],
        content = json['content'],
        username = json['username'],
        created = DateTime.parse(json["created"]),
        replies = [],
        plantCareModel = null

        {
          if (json.containsKey("replies")) {
            replies = (json["replies"] as List<dynamic>).map((e) => CommentModel.fromJSON(e)).toList();
          }
        }
        //author = User.fromJSON(jsonDecode('{"id": 1, "name": "Test"}')),
        
  CommentModel(this.authorID, this.parentID, this.content, this.username)
      : commentID = -1,
        score = 0,
        created = DateTime.now(),
        replies = [],
        plantCareModel = null;

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
