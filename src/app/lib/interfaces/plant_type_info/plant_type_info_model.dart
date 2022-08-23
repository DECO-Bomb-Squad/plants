import 'package:app/api/plant_api.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class PlantTypeInfoModel {
  String? plantName;
  String? scientificName;
  WaterLevel? waterLevel;
  SoilType? soilType;
  Difficulty? difficulty;
  String? description;
  List<String>? tags;
  List<String>? imageUrls;

  PlantTypeInfoModel.fromJSON(Map<String, dynamic> json)
      : plantName = json["plant_name"],
        scientificName = json["scientific_name"],
        waterLevel = json["water_level"],
        soilType = json["soil_type"],
        difficulty = json["difficulty"],
        description = json["description"],
        tags = (json["tags"] as List<dynamic>).map((e) => e as String).toList(),
        imageUrls = (json["imageUrls"] as List<dynamic>).map((e) => e as String).toList();

  PlantTypeInfoModel.empty(String this.plantName)
      : tags = [],
        imageUrls = [];

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

// Demo purposes only, delete + move final widget to diff file!
class PlantTypeInfoDemo extends StatefulWidget {
  PlantAPI api = GetIt.I<PlantAPI>();

  @override
  State<PlantTypeInfoDemo> createState() => PlantTypeInfoDemoState();
}

class PlantTypeInfoDemoState extends State<PlantTypeInfoDemo> {
  @override
  Widget build(BuildContext context) =>
      LoadingBuilder<PlantTypeInfoModel>(widget.api.getPlantTypeInfo("Rose"), (model) => Text(model.toString()));
}
