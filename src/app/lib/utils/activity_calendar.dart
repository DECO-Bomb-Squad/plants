import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Basic calendar to plot activities
// Updating the ActivityOccurenceModel by ading new activty dates
// and rebuilding a state will update the activties display
SfCalendar calendarMini(ActivityOccurenceModel a) {
  CalendarController calendarController = CalendarController();
  calendarController.selectedDate = DateTime.now();
  const double dateSize = 8;
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarController.view == CalendarView.month &&
        calendarTapDetails.targetElement != CalendarElement.calendarCell) {
      calendarController.view = CalendarView.schedule;
    } else if (calendarController.view == CalendarView.schedule &&
        calendarController.view != CalendarElement.calendarCell) {
      calendarController.view = CalendarView.month;
    }
  }

  return SfCalendar(
    selectionDecoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: lightHighlight, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      shape: BoxShape.rectangle,
    ),
    controller: calendarController,
    monthCellBuilder: (context, details) {
      // set the day cell background to watered colour for days that have watering occuring
      bool isWater =
          (details.appointments).where((element) => (element as Activity).eventName == 'watering').isNotEmpty;
      final Color backgroundColor = isWater ? darkHighlight : lightColour;
      return Container(
          decoration: BoxDecoration(color: backgroundColor, border: Border.all(color: darkColour, width: 0.5)),
          child: Center(
            child: Text(
              details.date.day.toString(),
              style: TextStyle(color: !isWater ? darkColour : lightColour),
            ),
          ));
    },
    headerHeight: 40,
    view: CalendarView.month,
    allowedViews: const [CalendarView.month, CalendarView.schedule],
    onTap: (calendarTapDetails) => calendarTapped(calendarTapDetails),
    headerStyle: const CalendarHeaderStyle(textStyle: TextStyle(fontSize: 16, color: darkColour)),
    monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        numberOfWeeksInView: 6,
        monthCellStyle: MonthCellStyle(
            textStyle: TextStyle(fontSize: dateSize, color: Colors.black),
            leadingDatesTextStyle: TextStyle(fontSize: dateSize, color: Colors.black),
            trailingDatesTextStyle: TextStyle(fontSize: dateSize, color: Colors.black))),
    todayTextStyle: const TextStyle(fontSize: dateSize),
    dataSource: ActivityDataSource(a.getActivities()),
  );
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
    return Activity(a.name, d, d, a.toColour(), true);
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
