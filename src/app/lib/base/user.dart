class User {
  final int id;
  String username;
  String email;
  int reputation;
  String? bio;
  List<int>? ownedPlantIDs;

  User.fromJSON(Map<String, dynamic> json)
      : id = json["userId"],
        username = json["username"],
        email = json["email"],
        reputation = json["reputation"],
        bio = json["bio"] == "" ? null : json["bio"];
}
