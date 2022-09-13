import 'package:app/utils/activity_calendar.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

class PlantCareProfile extends ChangeNotifier {
  int id;
  LocationType location;
  SoilType soilType;

  int daysBetweenWatering;
  int daysBetweenFertilising;
  int daysBetweenRepotting;

  PlantCareProfile.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        location = LocationType.values.byName(json["plantLocation"]),
        soilType = SoilType.values.byName(json["soilType"]),
        daysBetweenWatering = json["daysBetweenWatering"],
        daysBetweenFertilising = json["daysBetweenFertilizer"],
        daysBetweenRepotting = json["daysBetweenRepotting"];
}

class PlantInfoModel extends ChangeNotifier {
  // TODO add "owner" User when properly implemented - need json key changed
  int id;
  String? nickName;
  String plantName; // Common name
  String scientificName; // Botanical name

  ActivityOccurenceModel activities; // Map of various activities and the time they occured
  PlantCareProfile careProfile;

  List<String>? tags; // System and user-added info tags

  Map<DateTime, String> images;

  PlantInfoModel.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        plantName = json["plant_name"],
        scientificName = json["scientific_name"],
        tags = (json["tags"] as List<dynamic>).map((e) => e as String).toList(),
        nickName = json["nickname"],
        images = ((json["images"] ?? {}) as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry(DateTime.parse(key as String), value as String)),
        activities = ActivityOccurenceModel.fromListJSON(json["activities"]),
        careProfile = PlantCareProfile.fromJSON(json["careProfile"]) {
    activities.addListener(notifyListeners);
  }

  Widget getCoverPhoto(double height, double width, IconData iconData, double iconSize) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: images.isNotEmpty
            ? Image(
                image: NetworkImage(sortedImages[0]),
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
            : Icon(iconData, size: iconSize),
      );

  List<String> get sortedImages {
    // Reverse sort - most recent at start of list
    List<MapEntry<DateTime, String>> temp = images.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
    return temp.map((e) => e.value).toList();
  }

  int get timeSinceLastWater => DateTime.now().difference(activities.lastWatered).inDays;

  int get waterFrequency => careProfile.daysBetweenWatering;

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

  void addNewImage(String imageURL, DateTime time) {
    // TODO do api call here
    images[time] = imageURL;
    notifyListeners(); // trigger rebuild in widgets that share this model
  }

  void removeImage(String imageURL) {
    // TODO do api call here
    images.removeWhere((key, value) => value == imageURL);
    notifyListeners();
  }
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

  static SoilType? toSoilType(String s) {
    switch (s) {
      case "small pot":
        return SoilType.smallPot;
      case "medium pot":
        return SoilType.mediumPot;
      case "large pot":
        return SoilType.largePot;
      case "window planter":
        return SoilType.windowPlanter;
      case "garden bed":
        return SoilType.gardenBed;
      case "container of water":
        return SoilType.water;
      case "fish tank":
        return SoilType.fishTank;
      default:
        return null;
    }
  }

  static List<String?> allSoilTypes() {
    return SoilType.values.map((e) => e.toHumanString()).toList();
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

enum ActivityTypeId { watering, repotting, fertilising, worshipping }

extension ActivityColour on ActivityTypeId {
  Color toColour() {
    switch (index) {
      case 0:
        return darkHighlight;
      case 1:
        return secondaryAccent;
      case 2:
        return accent;
      case 3:
        return darkColour;
      default:
        return lightHighlight;
    }
  }
}
