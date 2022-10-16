import 'package:app/api/plant_api.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile.dart';
import 'package:app/plantinstance/plant_image_gallery.dart';
import 'package:app/screens/plant_care_screen.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:get_it/get_it.dart';

// Skeleton class for a plant that is loading in from the server.
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

// 'Small' summary form of a plant's info - navigates to full info screen upon clicking
class PlantInfoSmallWidget extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;
  const PlantInfoSmallWidget(this.model, this.plantID, {Key? key}) : super(key: key);

  @override
  State<PlantInfoSmallWidget> createState() => _PlantInfoSmallState();
}

class _PlantInfoSmallState extends State<PlantInfoSmallWidget> {
  // 'rebuild' method needs to listen for changes to the plant's model & visually display these changes
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

// 'Large' summary form of a plant's info - navigates to full info screen upon clicking
class PlantInfoLargeWidget extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;

  const PlantInfoLargeWidget(this.model, this.plantID, {super.key});

  @override
  State<PlantInfoLargeWidget> createState() => _PlantInfoLargeState();
}

class _PlantInfoLargeState extends State<PlantInfoLargeWidget> {
  // 'rebuild' method needs to listen for changes to the plant's model & visually display these changes
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
            widget.model.getCoverPhoto(100, 100, Icons.grass, 100),
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

// Full screen information page for everything related to the plant
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

  // Need to check if the plant is being accessed by the user who owns it - if not, hide buttons that can change the model
  late bool belongsToMe;

  // 'rebuild' method needs to listen for changes to the plant's model & visually display these changes
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

  Widget get nameWidget => DecoratedBox(
    decoration: smallPlantComponent,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [          
              Text(model.nickName ?? model.plantName, style: mainHeaderStyle),
              Text(model.scientificName, style: sectionHeaderStyle),
            ]
          ),
          Icon(model.condition.iconData(), size: 75)
        ],
      ),
    )
  );

  GestureDetector get photoGalleryButton => GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => PlantGalleryScreen(widget.plantID, widget.model),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            children: [
              const Text("Photos", style: subheaderStyle),
              spacer,
              model.getCoverPhoto(150, 150, Icons.photo, 150),
            ],
          ),
        ),
      );

  GestureDetector get activityCalendarButton => GestureDetector(
        onTap: navigateToActivityScreen,
        child: Column(
          children: const [
            Text("Activity History", style: subheaderStyle),
            Icon(Icons.calendar_month, size: 150),
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

  Widget get descriptionParagraph => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description", style: sectionHeaderStyle),
        Text(model.description!, style: textStyle)
      ],
    );

  Widget get careDetailsParagraph => Text(
      "Water every ${model.waterFrequency} days, repot every ${model.repotFrequency} days, fertilise every ${model.fertiliseFrequency} days. Planted in a ${model.careProfile.soilType.toHumanString()} located ${model.careProfile.location.toHumanString()}",
      style: modalTextStyle);

  Widget get healthHeader => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [Text("Health", style: subheaderStyle)],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(ActivityTypeId.watering.iconData(), color: darkHighlight),
              Text("Last watered ${model.timeSinceLastWater} days ago", style: modalTextStyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(ActivityTypeId.fertilising.iconData(), color: accent,),
              Text("Last fertilised ${model.timeSinceLastFertilise} days ago", style: modalTextStyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(ActivityTypeId.repotting.iconData(), color: secondaryAccent,),
              Text("Last repotted ${model.timeSinceLastRepot} days ago", style: modalTextStyle),
            ],
          ),
        ],
      );

  Column get careProfileDetails => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex:1,
                child: Icon(ActivityTypeId.watering.iconData(), size: 50.0),
              ),
              Flexible(
                flex:2,
                child: Text("Water every ${model.waterFrequency} days", style: modalTextStyle),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex:1,
                child: Icon(ActivityTypeId.fertilising.iconData(), size: 50.0),
              ),
              Flexible(
                flex:2,
                child: Text("Fertilise every ${model.fertiliseFrequency} days", style: modalTextStyle),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex:1,
                child: Icon(ActivityTypeId.repotting.iconData(), size: 50.0),
              ),
              Flexible(
                flex:2,
                child: Text("Repot every ${model.repotFrequency} days", style: modalTextStyle),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex:1,
                child: Icon(model.careProfile.soilType.iconData(), size: 40.0), // This icon set is bigger for some reason
              ),
              Flexible(
                flex:2,
                child: Text("Planted in ${model.careProfile.soilType.toHumanString()}", style: modalTextStyle),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex:1,
                child: Icon(model.careProfile.location.iconData(), size: 50.0),
              ),
              Flexible(
                flex:2,
                child: Text("Located ${model.careProfile.location.toHumanString()}", style: modalTextStyle),
              ),
            ],
          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: nameWidget,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      photoGalleryButton,
                      activityCalendarButton
                    ],
                  ),
                  if (model.description != null && model.description!.isNotEmpty) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: descriptionParagraph,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        healthHeader,
                        lastCareDetails,
                        Column(
                          children: [
                            Text("Water level", style: subheaderStyle,),
                            spacer,
                            model.getWaterMeterRow(MediaQuery.of(context).size.width * 0.7, 25),
                          ],
                        ),
                        spacer,
                        Text(model.condition.text(), style: sectionHeaderStyle),
                      ],
                    ),
                  ),
                
                  if (belongsToMe)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          markAsWateredButton,
                          activityOptionsButton,
                        ],
                      ),
                    ),
                  careHeader,
                  careProfileDetails,
                  spacer,
                ],
              ),
            ),
          ),
        ),
      );

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
