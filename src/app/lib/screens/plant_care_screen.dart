import 'dart:convert';

import 'package:app/api/plant_api.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/plantinstance/plant_info_model.dart';
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
  const PlantCareScreen(this.model, this.plantID, {super.key});

  @override
  State<PlantCareScreen> createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  ActivityOccurenceModel get activityModel => widget.model.activities;
  late bool belongsToMe;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
    int myId = GetIt.I<PlantAPI>().user!.id;
    int plantOwnerId = widget.model.ownerId;
    belongsToMe = (myId == plantOwnerId);
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(rebuild);
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SfCalendar calendar = calendarMini(activityModel);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: StandardHeaderBuilder,
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          children: [
                            Text(widget.model.nickName ?? widget.model.plantName, style: mainHeaderStyle),
                            Icon(widget.model.condition.iconData(), size: 50)
                          ],
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(widget.model.scientificName, style: sectionHeaderStyle),
                        )
                      ]),
                    ),
                    widget.model.getCoverPhoto(100, 100, Icons.photo, 100)
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
                                  onPressed: belongsToMe
                                      ? () {
                                          DateTime? selected = calendar.controller?.selectedDate;
                                          activityModel.addWatering(selected);
                                          setState(() {});
                                        }
                                      : null,
                                  style: waterButtonStyle,
                                  child: const Text(
                                    "Mark as Watered",
                                    style: buttonTextStyle,
                                  ))),
                          SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: TextButton(
                                  onPressed: belongsToMe
                                      ? () {
                                          DateTime? selected = calendar.controller?.selectedDate;
                                          activityModel.addFertilising(selected);
                                          setState(() {});
                                        }
                                      : null,
                                  style: buttonStyle,
                                  child: const Text(
                                    "Mark as Fertilised",
                                    style: buttonTextStyle,
                                  ))),
                          SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: TextButton(
                                  onPressed: belongsToMe
                                      ? () {
                                          DateTime? selected = calendar.controller?.selectedDate;
                                          activityModel.addRepotting(selected);
                                          setState(() {});
                                        }
                                      : null,
                                  style: buttonStyle,
                                  child: const Text(
                                    "Mark as Repotted",
                                    style: buttonTextStyle,
                                  ))),
                        ],
                      )),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
