import 'dart:convert';

import 'package:app/api/plant_api.dart';
import 'package:app/interfaces/plant_type_info/plant_type_info_model.dart';
import 'package:app/screens/plant_identification_screen.dart';
import 'package:intl/intl.dart';
import 'package:app/plantinstance/plant_info_model.dart' as info;
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';

class PlantAddScreen extends StatefulWidget {
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantAddScreen({super.key});

  @override
  State<PlantAddScreen> createState() => _PlantAddScreenState();
}

class _PlantAddScreenState extends State<PlantAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _dateInput = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  String soil = "small pot";
  PlantTypeInfoModel model = PlantTypeInfoModel.empty("rose");

  @override
  void initState() {
    super.initState();
    //model.addListener(rebuild);
  }

  @override
  void dispose() {
    super.dispose();
    //model.removeListener(rebuild);
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    model = PlantTypeInfoModel.empty("rose");
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
            body: Form(
                key: this._formKey,
                child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "I have a...",
                                style: mainHeaderStyle,
                              ),
                              spacer,
                              SizedBox(
                                  //width: MediaQuery.of(context).size.width * 0.7,
                                  child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: this._typeAheadController,
                                    decoration: InputDecoration(
                                        labelText: 'Plant',
                                        suffixIcon: IconButton(
                                            onPressed: () => showDialog(
                                                context: context, builder: (_) => PlantIdentificationDialog()),
                                            icon: Icon(Icons.camera_alt)))),
                                suggestionsCallback: (pattern) {
                                  PlantTypeInfoModel m = widget.api.getPlantTypes(pattern);
                                  return [m];
                                },
                                itemBuilder: (context, PlantTypeInfoModel suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.plantName ?? ""),
                                    subtitle: Text(suggestion.scientificName ?? ""),
                                  );
                                },
                                onSuggestionSelected: (PlantTypeInfoModel suggestion) {
                                  _typeAheadController.text = suggestion.plantName ?? "";
                                  model.plantName = suggestion.plantName;
                                  model.scientificName = suggestion.scientificName;
                                },
                                validator: (value) {
                                  if (value == "" || value == null) {
                                    return 'Please select a plant';
                                  }
                                },
                              )),
                              spacer,
                              const Text(
                                "planted on",
                                style: mainHeaderStyle,
                              ),
                              TextFormField(
                                  controller: _dateInput,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now());

                                    if (pickedDate != null) {
                                      String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
                                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        _dateInput.text = formattedDate; //set output date to TextField value.
                                      });
                                    } else {}
                                  }),
                              spacer,
                              const Text(
                                "in a",
                                style: mainHeaderStyle,
                              ),
                              spacer,
                              DropdownButton<String>(
                                  value: soil,
                                  items: info.SoilTypeExtension.allSoilTypes()
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e ?? "")))
                                      .toList(),
                                  onChanged: ((value) => setState(() => soil = value!))),
                              spacer,
                              SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  child: TextButton(
                                      onPressed: () {},
                                      style: buttonStyle,
                                      child: const Text(
                                        "Add Plant",
                                        style: buttonTextStyle,
                                      ))),
                            ],
                          ),
                        ])))));
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
