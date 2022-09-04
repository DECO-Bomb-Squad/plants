class PostInfoModel {
  int postID;       // Post ID in the DB
  int score;        // Reputation at the moment of the call
  String author;       // Who wrote the post
  String title;     // Post title
  String content;   // Post body - formatting
  DateTime created;

  List<int> attachedPlants; // IDs of attached plants

  PostInfoModel.fromJSON(Map<String, dynamic> json)
      : author = json["author"],
        postID = json["post_id"],
        score = json["score"],
        title = json["title"],
        content = json["content"],
        created = DateTime.parse(json["created"]),
        attachedPlants = (json["attached_plants"] as List<dynamic>).map((e) => e as int).toList();

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