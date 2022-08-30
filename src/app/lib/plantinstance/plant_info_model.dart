import 'dart:ffi';
import 'dart:ui';
import 'package:app/api/plant_api.dart';
import 'package:app/utils/loading_builder.dart';

class PlantInfoModel {
  String? plantName; // Common name
  String? scientificName; // Botanical name
  String? owner; // Who owns the plant?
  int? waterFrequency; // How many days between waterings

  ActivityOccurenceModel? activities; // Map of various activities and the time they occured

  List<String>? tags; // System and user-added info tags
  List<DateTime>? watered; // Dates of previous waterings

  SoilType? soilType; // How the plant is potted
  LocationType? location; // Where the plant is planted
  ConditionType? condition; // Status of the plant

  PlantInfoModel.fromJSON(Map<String, dynamic> json)
      : plantName = json["plant_name"],
        scientificName = json["scientific_name"],
        owner = json["owner"],
        waterFrequency = json["water_frequency"],
        activities = null, //ActivityOccurenceModel.fromListJSON(json["plantActivities"]),
        tags = (json["tags"] as List<dynamic>).map((e) => e as String).toList(),
        watered = (json["watered"] as List<dynamic>).map((e) => DateTime.parse(e)).toList(),
        soilType = SoilType.values.byName(json["soil_type"]),
        location = LocationType.values.byName(json["location"]),
        condition = ConditionType.normal; // Placeholder
}

class ActivityOccurenceModel {
  List<DateTime>? watering;
  List<DateTime>? repotting;
  List<DateTime>? fertilising;
  List<DateTime>? worshipping;

  ActivityOccurenceModel.fromListJSON(List<dynamic> json)
      : watering = (json.where((element) => element['activityTypeId'] == activityTypeId.watering.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        repotting = (json.where((element) => element['activityTypeId'] == activityTypeId.repotting.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        fertilising = (json.where((element) => element['activityTypeId'] == activityTypeId.fertilising.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        worshipping = (json.where((element) => element['activityTypeId'] == activityTypeId.worshipping.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [];
}

class Activity {
  /// Creates a meeting class with required details.
  Activity(this.eventName, this.from, this.to, this.background, this.isAllDay);

  static Activity activityFromType(activityTypeId a, DateTime d) {
    return Activity(a.name, d, d, Color.fromARGB(255, 0, 222, 214), false);
  }

  /// Event name which is equivalent to subject property of [Activity].
  String eventName;

  /// From which is equivalent to start time property of [Activity].
  DateTime from;

  /// To which is equivalent to end time property of [Activity].
  DateTime to;

  /// Background which is equivalent to color property of [Activity].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Activity].
  bool isAllDay;
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

enum ConditionType { normal, information, problem }

enum activityTypeId { watering, repotting, fertilising, worshipping }
