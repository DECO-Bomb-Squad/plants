class User {
  final int id;
  String name;
  List<int> ownedPlantIDs;

  User.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        ownedPlantIDs = (json["plantIds"] as List<dynamic>).map((e) => e as int).toList();
}
