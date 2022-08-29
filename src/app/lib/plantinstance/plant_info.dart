import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/plantinstance/plant_info_model.dart';

class PlantInfoWidget extends StatefulWidget {
  // Things that will not change after the widget is made are put here. Anything that can be changed by buttons, an API
  // updating the widget, etc. should be contained in the state. Any variables put in the widget should be final
  final String demoTitle;

  // This is the constructor for the widget - if you want to instantiate this widget you call this, with the required
  // arguments
  // use 'this.varname' in the constructor to automatically assign the arg to a class parameter :)
  // https://dart.dev/guides/language/language-tour#constructors
  const PlantInfoWidget(this.demoTitle, {Key? key}) : super(key: key);

  // Any StatefulWidget must override createState by calling the constructor for the state you define
  // You can use this arrow => to quickly return something instead of doing {return _DemoWidgetState();}
  @override
  State<PlantInfoWidget> createState() => _PlantInfoState();
}

class _PlantInfoState extends State<PlantInfoWidget> {
  var testJson = jsonDecode(
'''{
    "plant_name": "Common Monstera",
    "scientific_name": "Monstera Deliciosa",
    "owner": "Dr Kaczynski",
    "water_frequency": 7,
    "tags": [
        "Test tag"
    ],
    "watered": [
        "2022-07-14T21:52",
        "2022-08-28T23:28"
    ],
    "soil_type": "largePot",
    "location": "fullShade"
  }''');

  @override
  Widget build(BuildContext context) {
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