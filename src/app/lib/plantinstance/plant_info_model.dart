import 'package:app/PlantCareIcons_icons.dart';
import 'package:app/api/plant_api.dart';
import 'package:app/utils/activity_calendar.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';

// Stores information related to a plant's care details - care schedules, soil type and location.
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

  Future<bool> updatePlantCareProfile(EditPlantCareProfileModel model) async {
    // Set the fields to new ones specified in the edit model
    location = model.location!;
    soilType = model.soilType!;
    daysBetweenWatering = model.daysBetweenWatering!;
    daysBetweenFertilising = model.daysBetweenFertilising!;
    daysBetweenRepotting = model.daysBetweenRepotting!;
    // Make api call to ask server to update
    bool result = await GetIt.I<PlantAPI>().updatePlantCareProfile(this);
    notifyListeners();
    return result;
  }

  PlantCareProfile.newCareProfile(EditPlantCareProfileModel model)
      : id = 0, // placeholder vallue
        location = model.location!,
        soilType = model.soilType!,
        daysBetweenWatering = model.daysBetweenWatering!,
        daysBetweenFertilising = model.daysBetweenFertilising!,
        daysBetweenRepotting = model.daysBetweenRepotting!;
}

// Stores info received from back end about an individual plant.
class PlantInfoModel extends ChangeNotifier {
  int id;
  String? nickName;
  String plantName; // Common name
  String scientificName; // Botanical name
  String? description;

  int ownerId;
  String ownerName;

  ActivityOccurenceModel activities; // Map of various activities and the time they occured
  PlantCareProfile careProfile;

  Map<DateTime, String> images;

  PlantInfoModel.fromJSON(Map<String, dynamic> json)
      : id = json["id"],
        plantName = json["common_name"],
        scientificName = json["scientific_name"],
        description = json["description"],
        ownerId = (json["user"] as Map<dynamic, dynamic>).map((key, value) => MapEntry(key as String, value))["userId"],
        ownerName =
            (json["user"] as Map<dynamic, dynamic>).map((key, value) => MapEntry(key as String, value))["username"],
        nickName = json["name"],
        images = ((json["photos"] ?? {}) as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry(DateTime.parse(key as String), value as String)),
        activities = ActivityOccurenceModel.fromListJSON(json["id"], json["activities"]),
        careProfile = PlantCareProfile.fromJSON(json["careProfile"]) {
    activities.addListener(rebuild);
  }

  void rebuild() {
    // Tells anything listening to this model to rerender
    notifyListeners();
  }

  Widget getCoverPhoto(double height, double width, IconData iconData, double iconSize) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: images.isNotEmpty
            ? Image(
                image: CachedNetworkImageProvider(sortedImages[0]),
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

  int get timeSinceLastRepot => DateTime.now().difference(activities.lastRepotted).inDays;

  int get repotFrequency => careProfile.daysBetweenRepotting;

  int get timeSinceLastFertilise => DateTime.now().difference(activities.lastFertilised).inDays;

  int get fertiliseFrequency => careProfile.daysBetweenFertilising;

  ConditionType get condition {
    if (timeSinceLastWater > waterFrequency) {
      return ConditionType.needsWatering;
    } else if (timeSinceLastFertilise > fertiliseFrequency) {
      return ConditionType.needsFertilising;
    } else if (timeSinceLastRepot > repotFrequency) {
      return ConditionType.needsPotting;
    } else {
      return ConditionType.happy;
    }
  }

  double get waterTimePercentage {
    double fraction = 1.0 - timeSinceLastWater / waterFrequency;
    if (fraction > 1.0) {
      fraction = 1.0;
    } else if (fraction <= 0.0) {
      fraction = 0.01; // We want a little bit to show through the progress bar
    }
    return fraction;
  }

  Widget get wateringProgressBar => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: LinearProgressIndicator(
          value: waterTimePercentage,
          valueColor: const AlwaysStoppedAnimation<Color>(darkHighlight),
          backgroundColor: lightHighlight,
          minHeight: 20,
        ),
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
    GetIt.I<PlantAPI>().addPlantPhoto(imageURL, id);
    images[time] = imageURL;
    notifyListeners(); // trigger rebuild in widgets that share this model
  }

  void removeImage(String imageURL) {
    GetIt.I<PlantAPI>().removePlantPhoto(imageURL);
    images.removeWhere((key, value) => value == imageURL);
    notifyListeners();
  }
}

// Enum for information related to what material a plant is planted in
// Extension provides methods on these enum values
enum SoilType {
  smallPot,
  mediumPot,
  largePot,
  windowPlanter,
  gardenBed,
  water,
  fishTank,
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

  IconData iconData() {
    switch (this) {
      case SoilType.smallPot:
        return PlantCareIcons.small_pot;
      case SoilType.mediumPot:
        return PlantCareIcons.med_pot;
      case SoilType.largePot:
        return PlantCareIcons.large_pot;
      case SoilType.gardenBed:
        return PlantCareIcons.planter;
      case SoilType.water:
        return PlantCareIcons.vase;
      case SoilType.fishTank:
        return PlantCareIcons.tank;
      case SoilType.windowPlanter:
        return PlantCareIcons.window;
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

// Enum for location (i.e. light level) of the plant
// Extension provides methods on these enum values
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

  IconData iconData() {
    switch (this) {
      case LocationType.indoor:
        return PlantCareIcons.inside;
      case LocationType.fullShade:
        return PlantCareIcons.full_shade;
      case LocationType.fullSun:
        return PlantCareIcons.full_sun;
      case LocationType.partShade:
        return PlantCareIcons.half_sun;
    }
  }
}

// Enum for the current condition of the plant, derived from how recently it has been repotted, watered, ...
// Extension provides methods for the enum values
enum ConditionType {
  happy,
  needsWatering,
  needsPotting,
  needsFertilising,
  problem,
}

extension ConditionExtension on ConditionType {
  String text() {
    switch (this) {
      case ConditionType.happy:
        return "This plant is happy!";
      case ConditionType.needsPotting:
        return "This plant is in need of repotting!";
      case ConditionType.needsWatering:
        return "This plant needs to be watered!";
      case ConditionType.needsFertilising:
        return "This plant needs to be fertilised!";
      case ConditionType.problem:
        return "This plant is sick!";
    }
  }

  IconData iconData() {
    switch (this) {
      case ConditionType.happy:
        return Icons.check_circle_outlined;
      case ConditionType.needsPotting:
        return PlantCareIcons.repotting;
      case ConditionType.needsFertilising:
        return PlantCareIcons.needs_fertiliser;
      case ConditionType.needsWatering:
        return PlantCareIcons.watering;
      case ConditionType.problem:
        return Icons.sick;
    }
  }
}

// Enum for different activities possible
enum ActivityTypeId {
  watering,
  repotting,
  fertilising,
  worshipping,
}

extension ActivityColour on ActivityTypeId {
  int get dbIndex {
    switch (this) {
      case ActivityTypeId.watering:
        return 1;
      case ActivityTypeId.repotting:
        return 2;
      case ActivityTypeId.fertilising:
        return 3;
      case ActivityTypeId.worshipping:
        return 4;
    }
  }

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

  IconData iconData() {
    switch (this) {
      case ActivityTypeId.fertilising:
        return PlantCareIcons.fertilising;
      case ActivityTypeId.repotting:
        return PlantCareIcons.repotting;
      case ActivityTypeId.watering:
        return PlantCareIcons.watering;
      case ActivityTypeId.worshipping:
        return Icons.volunteer_activism;
    }
  }
}
