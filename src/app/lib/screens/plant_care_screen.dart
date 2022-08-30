import 'dart:convert';

import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/plantinstance/test_call.dart';
import 'package:app/utils/activity_calendar.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlantCareEmpty extends StatefulWidget {
  final int plantID;
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantCareEmpty(this.plantID, {super.key});

  @override
  State<PlantCareEmpty> createState() => _PlantCareEmptyState();
}

class _PlantCareEmptyState extends State<PlantCareEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: smallPlantComponent,
        child: LoadingBuilder(
            widget.api.getPlantInfo(widget.plantID), (m) => PlantCareScreen(m as PlantInfoModel, widget.plantID)));
  }
}

class PlantCareScreen extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;
  PlantCareScreen(this.model, this.plantID, {super.key});

  @override
  State<PlantCareScreen> createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  ActivityOccurenceModel activityModel =
      ActivityOccurenceModel.fromListJSON(jsonDecode(activitiesJson)["plantActivities"]);
  @override
  Widget build(BuildContext context) {
    SfCalendar calendar = calendarMini(activityModel);
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop())),
                  backgroundColor: lightColour,
                  shadowColor: lightColour,
                  pinned: false,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  iconTheme: const IconThemeData(color: darkHighlight, size: 35),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Add new entry',
                      onPressed: () {/* ... */},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      tooltip: 'Add new entry',
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ];
            },
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Text(widget.model.nickName ?? widget.model.plantName, style: mainHeaderStyle),
                              Icon(widget.model.condition.iconData(), size: 50)
                            ],
                          ),
                          Text(widget.model.scientificName, style: sectionHeaderStyle),
                        ]),
                      ),
                      widget.model.getCoverPhoto(100, 100, Icons.photo, 150)
                    ]),
                    calendar,
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                    onPressed: () {
                                      DateTime? selected = calendar.controller?.selectedDate;
                                      selected != null ? activityModel.watering?.add(selected) : null;
                                      setState(() {});
                                    },
                                    style: waterButtonStyle,
                                    child: const Text(
                                      "Mark as Watered",
                                      style: buttonTextStyle,
                                    ))),
                            SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                    onPressed: () {
                                      DateTime? selected = calendar.controller?.selectedDate;
                                      selected != null ? activityModel.fertilising?.add(selected) : null;
                                      setState(() {});
                                    },
                                    style: buttonStyle,
                                    child: const Text(
                                      "Mark as Fertilised",
                                      style: buttonTextStyle,
                                    ))),
                            SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                    onPressed: () {
                                      DateTime? selected = calendar.controller?.selectedDate;
                                      selected != null ? activityModel.repotting?.add(selected) : null;
                                      setState(() {});
                                    },
                                    style: buttonStyle,
                                    child: const Text(
                                      "Mark as Repotted",
                                      style: buttonTextStyle,
                                    ))),
                          ],
                        )),
                  ]),
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextButton(
                          onPressed: () {
                            DateTime? selected = calendar.controller?.selectedDate;
                            selected != null ? activityModel.fertilising?.add(selected) : null;
                            setState(() {});
                          },
                          style: buttonStyle,
                          child: const Text(
                            "Edit Plant",
                            style: buttonTextStyle,
                          ))),
                ],
              ),
            )));
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
