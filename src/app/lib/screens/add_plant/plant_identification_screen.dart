import 'dart:io';

import 'package:app/api/plant_api.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';

import 'package:app/plantinstance/plant_image_gallery.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class PlantIdentificationDialog extends StatefulWidget {
  List<PlantIdentifyModel> samples = [];
  List<IdentifyResult> res = [];
  PlantIdentificationDialog({super.key});

  @override
  State<PlantIdentificationDialog> createState() => _PlantIdentificationDialogState();
}

class _PlantIdentificationDialogState extends State<PlantIdentificationDialog> {
  final List<String> organs = ["leaf", "flower"];
  List<bool> organSelection = [true, false];
  PlantIdentifyModel currentAddition = PlantIdentifyModel("leaf", "");
  final PlantAPI api = GetIt.I<PlantAPI>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 1.25,
        ),
        decoration: dialogComponent,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Photo Identification", style: mainHeaderStyle)],
            ),
            spacer,
            Text("Select upto 5 photos and identify them as flowers or leaves", style: modalTextStyle),
            spacer,
            sampleAdder(),
            spacer,
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: GridView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 6, mainAxisSpacing: widget.samples.isNotEmpty ? 5 : 0),
                  children: widget.samples.map((e) => sampleItem(e)).toList()),
            ),
            widget.res.isEmpty
                ? spacer
                : Text(
                    "RESULTS",
                    style: modalTextStyle,
                  ),
            widget.res.isEmpty
                ? spacer
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                    child: GridView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.9,
                            childAspectRatio: 6 / 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        children: widget.res.map((e) => resultItem(e)).toList()),
                  ),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              TextButton(
                  onPressed: () async {
                    widget.res = await api.getPlantNetResults(widget.samples);
                    rebuild();
                  },
                  style: buttonStyle,
                  child: Text(
                    "API",
                    style: buttonTextStyle,
                  )),
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  style: buttonStyle,
                  child: Text(
                    "ADD",
                    style: buttonTextStyle,
                  ))
            ])
          ],
        ),
      ),
    );
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);

  Widget sampleAdder() => SizedBox(
      height: 50,
      child: DecoratedBox(
          decoration: smallPostComponent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                currentAddition.isEmpty() ? unchosenImage() : chosenImage(currentAddition.image),
                Container(
                    height: 30,
                    decoration: BoxDecoration(color: lightColour, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ToggleButtons(
                        direction: Axis.horizontal,
                        textStyle: modalTextStyle,
                        borderRadius: BorderRadius.circular(10),
                        fillColor: accent,
                        borderColor: lightColour,
                        selectedColor: darkColour,
                        selectedBorderColor: lightColour,
                        children: [Text("Leaf"), Text("Flower")],
                        onPressed: (index) => setState(() {
                              organSelection = [false, false];
                              organSelection[index] = true;
                              currentAddition.organ = organs[index];
                            }),
                        isSelected: organSelection)),
                SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() {
                              currentAddition.image = "";
                              currentAddition.organ = organs[0];
                              organSelection = [true, false];
                            }),
                        icon: Icon(Icons.refresh, color: darkColour))),
                widget.samples.length >= 5
                    ? spacer
                    : SizedBox(
                        height: 30,
                        width: 30,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => currentAddition.isEmpty()
                                ? null
                                : setState(() {
                                    widget.samples
                                        .add(PlantIdentifyModel(currentAddition.organ, currentAddition.image));
                                    currentAddition.image = "";
                                    currentAddition.organ = organs[0];
                                    organSelection = [true, false];
                                  }),
                            icon: Icon(Icons.add, color: darkColour))),
              ])));

  Widget unchosenImage() => Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
        SizedBox(height: 50, width: 50, child: imageGetter("Camera", Icons.camera_alt, ImageSource.camera)),
        SizedBox(height: 50, width: 50, child: imageGetter("Gallery", Icons.photo, ImageSource.gallery)),
      ]);

  Widget chosenImage(String path) => Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.fitWidth)));

  Widget imageGetter(String subtitleText, IconData icon, ImageSource source) => Container(
        decoration: smallPostComponent,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => addImage(source),
                icon: Icon(icon),
              ),
            ),
          ],
        ),
      );

  Widget sampleItem(PlantIdentifyModel m) => SizedBox(
      height: 50,
      child: DecoratedBox(
          decoration: smallPlantComponent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chosenImage(m.image),
                Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      "${m.organ.toUpperCase()}",
                      style: buttonTextStyle,
                    )),
                SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() {
                              widget.samples.remove(m);
                            }),
                        icon: const Icon(Icons.delete, color: darkColour))),
              ])));

  Widget resultItem(IdentifyResult m) => GestureDetector(
      onTap: () => Navigator.pop(context, m.science.toLowerCase()),
      child: SizedBox(
          height: 50,
          child: DecoratedBox(
              decoration: smallPlantComponent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(
                          "${m.science}",
                          style: buttonTextStyle,
                        )),
                    Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(
                          "${double.parse((m.score * 100).toStringAsFixed(1))}%",
                          style: buttonTextStyle,
                        )),
                  ]))));

  void addImage(ImageSource source) async {
    // get Image from imagepicker
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    currentAddition.image = image.path;
    setState(() {});
  }
}

class PlantIdentifyModel {
  String organ;
  String image;
  PlantIdentifyModel(this.organ, this.image);

  bool isEmpty() {
    if (image == "") {
      return true;
    } else {
      return false;
    }
  }
}

class IdentifyResult {
  String science;
  double score;
  IdentifyResult(this.science, this.score);
}
