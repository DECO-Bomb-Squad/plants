class PlantTypeInfoModel {
  final String plantName;
  final String scientificName;
  final WaterLevel waterLevel;
  final SoilType soilType;
  final Difficulty difficulty;
  final String description;
  final List<String> tags;
  final List<String> imageUrls;

  PlantTypeInfoModel.fromJSON(Map<String, dynamic> json)
      : plantName = json["plant_name"],
        scientificName = json["scientific_name"],
        waterLevel = json["water_level"],
        soilType = json["soil_type"],
        difficulty = json["difficulty"],
        description = json["description"],
        tags = (json["tags"] as List<String>),
        imageUrls = (json["imageUrls"] as List<String>);

  // temp - can remove when a matching widget is made
  @override
  String toString() => "Plant name: $plantName! Scientific Name: $scientificName";
}

enum WaterLevel {
  low,
  medium,
  high,
}

enum SoilType {
  allPurpose,
  indoor,
  succulent,
}

enum Difficulty {
  beginner,
  average,
  experienced,
  advanced,
}
