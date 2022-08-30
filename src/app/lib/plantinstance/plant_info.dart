import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/plantinstance/test_call.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlantInfoWidget extends StatefulWidget {
  final int plantID;
  const PlantInfoWidget(this.plantID, {Key? key}) : super(key: key);

  @override
  State<PlantInfoWidget> createState() => _PlantInfoState();
}

class _PlantInfoState extends State<PlantInfoWidget> {
  @override
  Widget build(BuildContext context) {
    var testJson = jsonDecode(rawJson)[widget.plantID];
    var actJson = jsonDecode(activitiesJson)["plantActivities"];
    PlantInfoModel model = PlantInfoModel.fromJSON(testJson);
    ActivityOccurenceModel act = ActivityOccurenceModel.fromListJSON(actJson);
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (_) => PlantInfoDialog(model: model, a: act));
      },
      child: Container(
          decoration: smallPlantComponent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [Icon(Icons.check_circle, size: 40), Icon(Icons.grass, size: 40)],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(model.plantName!, style: subheaderStyle, textAlign: TextAlign.center),
                  Text(model.owner!, style: textStyle, textAlign: TextAlign.center)
                ],
              )
            ],
          )),
    );
  }
}

SfCalendar calendarMini(ActivityOccurenceModel a) {
  return SfCalendar(
    //appointmentBuilder: appointmentBuilder,
    monthCellBuilder: (context, details) {
      bool isWater =
          (details.appointments).where((element) => (element as Activity).eventName == 'watering').length > 0;
      final Color backgroundColor = isWater ? Colors.blue : lightColour;
      return Container(
          decoration: BoxDecoration(color: backgroundColor, border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: Text(
              details.date.day.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ));
    },
    headerHeight: 15,
    view: CalendarView.month,
    headerStyle: CalendarHeaderStyle(textStyle: TextStyle(fontSize: 8, color: Colors.black)),
    monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        numberOfWeeksInView: 6,
        monthCellStyle: MonthCellStyle(
            textStyle: TextStyle(fontSize: 8, color: Colors.black),
            leadingDatesTextStyle: TextStyle(fontSize: 8, color: Colors.black),
            trailingDatesTextStyle: TextStyle(fontSize: 8, color: Colors.black))),
    todayTextStyle: TextStyle(fontSize: 8),
    dataSource: ActivityDataSource(a.getActivities()),
    // by default the month appointment display mode set as Indicator, we can
    // change the display mode as appointment using the appointment display
    // mode property
    //monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
  );
}

Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
  final Activity appointment = calendarAppointmentDetails.appointments.first;
  return Column(
    children: [
      Container(
        width: calendarAppointmentDetails.bounds.width,
        height: calendarAppointmentDetails.bounds.height * 2,
        color: Colors.blue,
      ),
    ],
  );
}

class PlantInfoDialog extends StatelessWidget {
  final PlantInfoModel model;
  final ActivityOccurenceModel a;
  const PlantInfoDialog({super.key, required this.model, required this.a});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: lightColour,
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(model.plantName!, style: mainHeaderStyle),
                Text(model.scientificName!, style: sectionHeaderStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.photo, size: 150),
                    //const Icon(Icons.calendar_month, size: 150),
                    IgnorePointer(child: Container(width: 100, height: 120, child: calendarMini(a))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      style: waterButtonStyle,
                      child: const Text("Mark as watered", style: buttonTextStyle),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      style: buttonStyle,
                      child: const Text("More options", style: buttonTextStyle),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        "Recommended to water every ${model.waterFrequency!} days. Last watered ${DateTime.now().difference(model.watered!.last).inDays.toString()} days ago. Planted in a ${model.soilType!.toHumanString()} located ${model.location!.toHumanString()}",
                        style: modalTextStyle))
              ],
            ),
          ),
        ));
  }
}
