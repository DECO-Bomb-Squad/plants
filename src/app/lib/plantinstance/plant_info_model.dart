import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

class PlantInfoModel {
  String? nickName;
  String plantName; // Common name
  String scientificName; // Botanical name
  String owner; // Who owns the plant?
  int waterFrequency; // How many days between waterings

  List<String>? tags; // System and user-added info tags
  List<DateTime> watered; // Dates of previous waterings

  SoilType? soilType; // How the plant is potted
  LocationType? location; // Where the plant is planted

  List<String> pictures; // list of image uris

  PlantInfoModel.fromJSON(Map<String, dynamic> json)
      : plantName = json["plant_name"],
        scientificName = json["scientific_name"],
        owner = json["owner"],
        waterFrequency = json["water_frequency"],
        tags = (json["tags"] as List<dynamic>).map((e) => e as String).toList(),
        watered = (json["watered"] as List<dynamic>).map((e) => DateTime.parse(e)).toList()..sort(),
        soilType = SoilType.values.byName(json["soil_type"]),
        location = LocationType.values.byName(json["location"]),
        nickName = json["nickname"],
        pictures = ((json["pictures"] ?? []) as List<dynamic>).map((e) => e as String).toList(); // Placeholder

  Widget getCoverPhoto(double height, double width, IconData iconData, double iconSize) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: pictures.isNotEmpty
            ? Image(
                image: NetworkImage(pictures[0]),
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
            : Icon(iconData, size: iconSize),
      );

  int get timeSinceLastWater => DateTime.now().difference(watered.last).inDays;

  ConditionType get condition =>
      (timeSinceLastWater > waterFrequency) ? ConditionType.needsWatering : ConditionType.happy;

  double get waterTimePercentage {
    double fraction = 1.0 - timeSinceLastWater / waterFrequency;
    if (fraction > 1.0) {
      fraction = 1.0;
    } else if (fraction <= 0.0) {
      fraction = 0.01; // We want a little bit to show through the progress bar
    }
    return fraction;
  }

  Widget get wateringProgressBar => LinearProgressIndicator(
        value: waterTimePercentage,
        valueColor: const AlwaysStoppedAnimation<Color>(darkHighlight),
        backgroundColor: lightHighlight,
        minHeight: 20,
      );

  Row getWaterMeterRow(double meterWidth, double iconSize) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop_outlined, size: iconSize),
          SizedBox(
            width: meterWidth,
            child: wateringProgressBar,
          ),
          Icon(Icons.water_drop, size: iconSize),
        ],
      );
}

enum SoilType { smallPot, mediumPot, largePot, windowPlanter, gardenBed, water, fishTank }

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

enum ConditionType { happy, needsWatering, needsPotting, problem }

extension ConditionExtension on ConditionType {
  String text() {
    switch (this) {
      case ConditionType.happy:
        return "This plant is happy!";
      case ConditionType.needsPotting:
        return "This plant is in need of repotting!";
      case ConditionType.needsWatering:
        return "This plant needs to be watered!";
      case ConditionType.problem:
        return "This plant is sick!";
    }
  }

  IconData iconData() {
    switch (this) {
      case ConditionType.happy:
        return Icons.sentiment_satisfied_alt;
      case ConditionType.needsPotting:
        return Icons.compost;
      case ConditionType.needsWatering:
        return Icons.water_drop_outlined;
      case ConditionType.problem:
        return Icons.sick;
    }
  }
}
