import 'package:flutter/material.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/utils/colour_scheme.dart';

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
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      showDialog(
        context: context, 
        builder: (_) => const PlantInfoDialog()
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("PlantName", style: subheaderStyle),
              Text("Owner", style: textStyle)
            ],
          )
          
        ],
      )
    ),
  );
}

class PlantInfoDialog extends StatelessWidget {
  const PlantInfoDialog({super.key});

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
            const Text("PlantName", style: mainHeaderStyle),
            const Text("BotanicalName", style: sectionHeaderStyle),
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
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Plant care info. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: modalTextStyle
              )
            )
            
          ],
        ),
      ),
    );
  }
}