import 'package:app/api/plant_api.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:get_it/get_it.dart';

class PlantInfoSmallEmpty extends StatefulWidget {
  final int plantID;
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantInfoSmallEmpty(this.plantID, {Key? key}) : super(key: key);

  @override
  State<PlantInfoSmallEmpty> createState() => _PlantInfoSmallEmptyState();
}

class _PlantInfoSmallEmptyState extends State<PlantInfoSmallEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: smallPlantComponent,
        child: LoadingBuilder(widget.api.getPlantInfo(widget.plantID), (m) => PlantInfoSmallWidget(m)));
  }
}

class PlantInfoSmallWidget extends StatefulWidget {
  final PlantInfoModel model;
  const PlantInfoSmallWidget(this.model, {Key? key}) : super(key: key);

  @override
  State<PlantInfoSmallWidget> createState() => _PlantInfoSmallState();
}

class _PlantInfoSmallState extends State<PlantInfoSmallWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => PlantInfoDialog(
                  model: widget.model,
                ));
      },
      child: Container(
          decoration: smallPlantComponent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.check_circle, size: 40),
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
    );
  }
}

class PlantInfoDialog extends StatelessWidget {
  final PlantInfoModel model;
  const PlantInfoDialog({super.key, required this.model});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(model.plantName, style: mainHeaderStyle),
            Text(model.scientificName, style: sectionHeaderStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                model.getCoverPhoto(150, 150, Icons.photo, 150),
                const Icon(Icons.calendar_month, size: 150),
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
                    "Recommended to water every ${model.waterFrequency} days. Last watered ${DateTime.now().difference(model.watered!.last).inDays.toString()} days ago. Planted in a ${model.soilType!.toHumanString()} located ${model.location!.toHumanString()}",
                    style: modalTextStyle))
          ],
        ),
      ),
    );
  }
}
