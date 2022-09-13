import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_image_gallery.dart';
import 'package:app/screens/plant_care_screen.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
    widget.model.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (_) => PlantInfoDialog(widget.model, () => setState(() {}), widget.plantID));
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
    widget.model.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (_) => PlantInfoDialog(widget.model, () => setState(() {}), widget.plantID));
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

class PlantInfoDialog extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;
  final void Function() rebuildParent;

  const PlantInfoDialog(this.model, this.rebuildParent, this.plantID, {super.key});

  @override
  State<PlantInfoDialog> createState() => _PlantInfoDialogState();
}

class _PlantInfoDialogState extends State<PlantInfoDialog> {
  PlantInfoModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 1.5,
        ),
        decoration: dialogComponent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(model.nickName ?? model.plantName, style: mainHeaderStyle),
                Icon(model.condition.iconData(), size: 50)
              ],
            ),
            Text(model.scientificName, style: sectionHeaderStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => PlantGalleryScreen(widget.plantID, widget.model),
                    ),
                  ),
                  child: model.getCoverPhoto(150, 150, Icons.photo, 150),
                ),
                const Icon(Icons.calendar_month, size: 150),
              ],
            ),
            model.getWaterMeterRow(200, 30),
            Text(model.condition.text(), style: textStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.rebuildParent();
                    setState(() {
                      model.watered.add(DateTime.now());
                      model.watered.sort();
                    });
                  },
                  style: waterButtonStyle,
                  child: const Text("Mark as watered", style: buttonTextStyle),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context, rootNavigator: false)
                      .push(MaterialPageRoute(builder: (context) => PlantCareEmpty(widget.plantID))),
                  style: buttonStyle,
                  child: const Text("More options", style: buttonTextStyle),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    "Recommended to water every ${model.waterFrequency} days. Last watered ${model.timeSinceLastWater} days ago. Planted in a ${model.soilType!.toHumanString()} located ${model.location!.toHumanString()}",
                    style: modalTextStyle))
          ],
        ),
      ),
    );
  }
}
