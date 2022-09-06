class PlantImageGalleryModel {
  int plantID;
  Map<DateTime, String> datedURIs;

  PlantImageGalleryModel.fromJSON(Map<String, dynamic> json)
      : plantID = json["plantID"],
        datedURIs = (json["images"] as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry(DateTime.parse(key as String), value as String));

  List<String> get sortedImages {
    List<MapEntry<DateTime, String>> temp = datedURIs.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return temp.map((e) => e.value).toList();
  }
}
