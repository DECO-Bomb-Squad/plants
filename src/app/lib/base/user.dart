class User {
  final int id;
  final String name;

  User.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
