import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/plantinstance/test_call.dart';

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
    PlantInfoModel model = PlantInfoModel.fromJSON(testJson);
    return InkWell(
      onTap: () {
        showDialog(
          context: context, 
          builder: (_) => PlantInfoDialog(model: model,)
        );
      },
      child: Container(
        decoration: smallPlantComponent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.check_circle, size: 40),
                Icon(Icons.grass, size: 40)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(model.plantName!, style: subheaderStyle, textAlign: TextAlign.center),
                Text(model.owner!, style: textStyle, textAlign: TextAlign.center)
              ],
            )
            
          ],
        )
      ),
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
            Text(model.plantName!, style: mainHeaderStyle),
            Text(model.scientificName!, style: sectionHeaderStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.photo, size: 150),
                Icon(Icons.calendar_month, size: 150)
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
                style: modalTextStyle
              )
            )
            
          ],
        ),
      ),
    );
  }
}