import 'dart:ffi';
import 'dart:ui';
import 'package:app/api/plant_api.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      : watering = (json.where((element) => element['activityTypeId'] == ActivityTypeId.watering.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        repotting = (json.where((element) => element['activityTypeId'] == ActivityTypeId.repotting.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        fertilising = (json.where((element) => element['activityTypeId'] == ActivityTypeId.fertilising.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [],
        worshipping = (json.where((element) => element['activityTypeId'] == ActivityTypeId.worshipping.index))
                .map((e) => DateTime.parse(e["time"]))
                .toList() ??
            [];

  List<Activity> getActivities() {
    List<Activity> activities = [];
    watering?.forEach((element) {
      activities.add(Activity.activityFromType(ActivityTypeId.watering, element));
    });
    repotting?.forEach((element) {
      activities.add(Activity.activityFromType(ActivityTypeId.repotting, element));
    });
    fertilising?.forEach((element) {
      activities.add(Activity.activityFromType(ActivityTypeId.fertilising, element));
    });
    worshipping?.forEach((element) {
      activities.add(Activity.activityFromType(ActivityTypeId.worshipping, element));
    });

    return activities;
  }
}

class Activity {
  /// Creates a activity class with required details.
  Activity(this.eventName, this.from, this.to, this.background, this.isAllDay);

  static Activity activityFromType(ActivityTypeId a, DateTime d) {
    return Activity(a.name, d, d, a.toColour(), false);
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

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class ActivityDataSource extends CalendarDataSource {
  /// Creates a activity data source, which used to set the appointment
  /// collection to the calendar
  ActivityDataSource(List<Activity> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getActivityData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getActivityData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getActivityData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getActivityData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getActivityData(index).isAllDay;
  }

  Activity _getActivityData(int index) {
    final dynamic activity = appointments![index];
    late final Activity activityData;
    if (activity is Activity) {
      activityData = activity;
    }

    return activityData;
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
