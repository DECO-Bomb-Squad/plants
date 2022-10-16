class PostInfoModel {
  int postID;       // Post ID in the DB
  int score;        // Reputation at the moment of the call
  int authorID;    // Who wrote the post
  String username;
  String title;     // Post title
  String content;   // Post body - formatting
  DateTime created; // When the post was written

  List<dynamic> attachedPlants; // IDs of attached plants
  List<dynamic> comments;

  PostInfoModel.fromJSON(Map<String, dynamic> json)
      : authorID = json["userId"],
        username = json["username"],
        postID = json["postId"],
        score = json["score"],
        title = json["title"],
        content = json["content"],
        created = DateTime.parse(json["created"]),
        attachedPlants = json["linkedPlants"],
        comments = json["comments"];

  PostInfoModel(this.authorID, this.username, this.title, this.content, this.attachedPlants)
      : postID = -1,
        score = 0,
        created = DateTime.now().add(const Duration(hours: 10)),
        comments = [];

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