import 'package:app/api/plant_api.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile.dart';
import 'package:app/plantinstance/plant_image_gallery.dart';
import 'package:app/screens/plant_care_screen.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:get_it/get_it.dart';

class PlantInfoEmpty extends StatefulWidget {
  final int plantID;
  final PlantAPI api = GetIt.I<PlantAPI>();
  final bool isSmall;
  PlantInfoEmpty(this.plantID, {super.key, required this.isSmall});

  @override
  State<PlantInfoEmpty> createState() => _PlantInfoEmptyState();
}

class _PlantInfoEmptyState extends State<PlantInfoEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: smallPlantComponent,
        child: LoadingBuilder(
            widget.api.getPlantInfo(widget.plantID),
            (m) => widget.isSmall
                ? PlantInfoSmallWidget(m as PlantInfoModel, widget.plantID)
                : PlantInfoLargeWidget(m as PlantInfoModel, widget.plantID)));
  }
}

class PlantInfoSmallWidget extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;
  const PlantInfoSmallWidget(this.model, this.plantID, {Key? key}) : super(key: key);

  @override
  State<PlantInfoSmallWidget> createState() => _PlantInfoSmallState();
}

class _PlantInfoSmallState extends State<PlantInfoSmallWidget> {
  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
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
    return Material(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (_) => PlantInfoScreen(widget.model, () => setState(() {}), widget.plantID));
      },
      child: Container(
          decoration: smallPlantComponent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(widget.model.condition.iconData(), size: 50),
                  widget.model.getCoverPhoto(80, 80, Icons.grass, 40),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.model.nickName ?? widget.model.plantName,
                      style: subheaderStyle, textAlign: TextAlign.center),
                  Text(widget.model.scientificName, style: textStyle, textAlign: TextAlign.center)
                ],
              )
            ],
          )),
    ));
  }
}

class PlantInfoLargeWidget extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;

  const PlantInfoLargeWidget(this.model, this.plantID, {super.key});

  @override
  State<PlantInfoLargeWidget> createState() => _PlantInfoLargeState();
}

class _PlantInfoLargeState extends State<PlantInfoLargeWidget> {
  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
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
    return Material(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (_) => PlantInfoScreen(widget.model, () => setState(() {}), widget.plantID));
      },
      child: Container(
        decoration: smallPlantComponent,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.model.getCoverPhoto(100, 100, Icons.grass, 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.model.nickName ?? widget.model.plantName, style: mainHeaderStyle),
                      Icon(widget.model.condition.iconData(), size: 50),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.model.scientificName, style: textStyle, textAlign: TextAlign.center),
                  ),
                  widget.model.getWaterMeterRow(120, 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class PlantInfoScreen extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;
  final void Function() rebuildParent;

  const PlantInfoScreen(this.model, this.rebuildParent, this.plantID, {super.key});

  @override
  State<PlantInfoScreen> createState() => _PlantInfoScreenState();
}

class _PlantInfoScreenState extends State<PlantInfoScreen> {
  PlantInfoModel get model => widget.model;

  late bool belongsToMe;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
    widget.model.careProfile.addListener(rebuild);
    int myId = GetIt.I<PlantAPI>().user!.id;
    int plantOwnerId = model.ownerId;
    belongsToMe = (myId == plantOwnerId);
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(rebuild);
    widget.model.careProfile.removeListener(rebuild);
  }

  void rebuild() {
    setState(() {});
  }

  void navigateToActivityScreen() => Navigator.of(context, rootNavigator: false)
      .push(MaterialPageRoute(builder: (context) => PlantCareEmpty(widget.plantID)));

  Row get nameRow => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(model.nickName ?? model.plantName, style: mainHeaderStyle),
              Text(model.scientificName, style: sectionHeaderStyle),
            ],
          ),
          Icon(model.condition.iconData(), size: 75)
        ],
      );

  GestureDetector get photoGalleryButton => GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => PlantGalleryScreen(widget.plantID, widget.model),
          ),
        ),
        child: Column(
          children: [
            model.getCoverPhoto(150, 150, Icons.photo, 150),
            const Text("Photos", style: subheaderStyle),
          ],
        ),
      );

  GestureDetector get activityCalendarButton => GestureDetector(
        onTap: navigateToActivityScreen,
        child: Column(
          children: const [
            Icon(Icons.calendar_month, size: 150),
            Text("Activity History", style: subheaderStyle),
          ],
        ),
      );

  ElevatedButton get markAsWateredButton => ElevatedButton(
        onPressed: () {
          widget.rebuildParent();
          setState(() {
            model.activities.addWatering(DateTime.now());
          });
        },
        style: waterButtonStyle,
        child: const Text("Mark as watered", style: buttonTextStyle),
      );

  ElevatedButton get editCareProfileButton => ElevatedButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => EditPlantCareProfile(profile: model.careProfile, plant: model));
        },
        style: buttonStyle,
        child: const Text("Edit", style: buttonTextStyle),
      );

  ElevatedButton get activityOptionsButton => ElevatedButton(
        onPressed: navigateToActivityScreen,
        style: buttonStyle,
        child: const Text("More options", style: buttonTextStyle),
      );

  Widget get descriptionParagraph => Text(model.description!, style: modalTextStyle);

  Widget get careDetailsParagraph => Text(
      "Water every ${model.waterFrequency} days, repot every ${model.repotFrequency} days, fertilise every ${model.fertiliseFrequency} days. Planted in a ${model.careProfile.soilType.toHumanString()} located ${model.careProfile.location.toHumanString()}",
      style: modalTextStyle);

  Widget get healthHeader => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [Text("Health", style: sectionHeaderStyle)],
      );

  Widget get careHeader => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Care Profile", style: sectionHeaderStyle),
          if (belongsToMe) editCareProfileButton,
        ],
      );

  Column get lastCareDetails => Column(
        children: [
          Text("Last watered ${model.timeSinceLastWater} days ago", style: modalTextStyle),
          Text("Last fertilised ${model.timeSinceLastFertilise} days ago", style: modalTextStyle),
          Text("Last repotted ${model.timeSinceLastRepot} days ago", style: modalTextStyle),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          scrollDirection: Axis.vertical,
          scrollBehavior: const MaterialScrollBehavior(),
          headerSliverBuilder: StandardHeaderBuilder,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  nameRow,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      photoGalleryButton,
                      spacer,
                      activityCalendarButton,
                    ],
                  ),
                  if (model.description != null && model.description!.isNotEmpty) descriptionParagraph,
                  healthHeader,
                  model.getWaterMeterRow(200, 30),
                  Text(model.condition.text(), style: textStyle),
                  spacer,
                  lastCareDetails,
                  if (belongsToMe)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        markAsWateredButton,
                        activityOptionsButton,
                      ],
                    ),
                  careHeader,
                  careDetailsParagraph,
                ],
              ),
            ),
          ),
        ),
      );

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
