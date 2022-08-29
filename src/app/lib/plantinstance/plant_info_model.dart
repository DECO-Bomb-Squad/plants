import 'dart:ffi';
import 'package:app/api/plant_api.dart';
import 'package:app/utils/loading_builder.dart';

class PlantInfoModel {
  String? plantName;      // Common name
  String? scientificName; // Botanical name
  String? owner;          // Who owns the plant?
  int? waterFrequency;    // How many days between waterings

  List<String>? tags;     // System and user-added info tags
  List<DateTime>? watered;// Dates of previous waterings

  SoilType? soilType;     // How the plant is potted
  LocationType? location;     // Where the plant is planted
  ConditionType? condition;   // Status of the plant
  

  PlantInfoModel.fromJSON(Map<String, dynamic> json)
  : plantName = json["plant_name"],
    scientificName = json["scientific_name"],
    owner = json["owner"],
    waterFrequency = json["water_frequency"],
    tags = (json["tags"] as List<dynamic>).map((e) => e as String).toList(),
    watered = (json["watered"] as List<dynamic>).map((e) => DateTime.parse(e)).toList(),
    soilType = SoilType.values.byName(json["soil_type"]),
    location = LocationType.values.byName(json["location"]),
    condition = ConditionType.normal; // Placeholder
}

enum SoilType {
  smallPot,
  mediumPot,
  largePot,
  windowPlanter,
  gardenBed,
  water,
  fishTank
}

extension SoilTypeExtension on SoilType {
  String? toHumanString() {
    switch (index) {
      case 0:
        return "small pot";
      case 1:
        return "medium pot";
      case 2:
        return "large pot";
      case 3:
        return "window planter";
      case 4:
        return "garden bed";
      case 5:
        return "container of water";
      case 6:
        return "fish tank";
      default:
        return null;
    }
  }
}

enum LocationType {
  indoor,
  fullShade,
  partShade,
  fullSun,
}

extension LocationExtension on LocationType {
  String? toHumanString() {
    switch (index) {
      case 0:
        return "indoors";
      case 1:
        return "in full shade";
      case 2:
        return "in partial shade";
      case 3:
        return "in full sunlight";
      default:
        return null;
    }
  }
}

enum ConditionType {
  normal,
  information,
  problem
}