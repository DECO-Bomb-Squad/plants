import 'package:app/api/plant_api.dart';
import 'package:app/screens/add_plant/plant_type_model.dart';
import 'package:app/screens/add_plant/plant_identification_screen.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:intl/intl.dart';
import 'package:app/plantinstance/plant_info_model.dart' as info;
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';

class PlantAddEmpty extends StatefulWidget {
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantAddEmpty({super.key});

  @override
  State<PlantAddEmpty> createState() => _PlantAddEmptyState();
}

class _PlantAddEmptyState extends State<PlantAddEmpty> {
  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(widget.api.getPlantTypes(), (m) => PlantAddScreen(m as List<PlantTypeModel>));
  }
}

class PlantAddScreen extends StatefulWidget {
  final List<PlantTypeModel> listTypes;
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantAddScreen(this.listTypes, {super.key});

  @override
  State<PlantAddScreen> createState() => _PlantAddScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _typeAheadController = TextEditingController();
final TextEditingController _dateInput = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));

class _PlantAddScreenState extends State<PlantAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _dateInput = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String soil = "small pot";
  PlantTypeModel model = PlantTypeModel.empty("", "");

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading:
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop())),
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
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
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
                                    controller: _typeAheadController,
                                    decoration: InputDecoration(
                                        labelText: 'Plant',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (_) => PlantIdentificationDialog())
                                                  .then((value) => {
                                                        value != null
                                                            ? model = widget.listTypes.firstWhere(
                                                                (element) =>
                                                                    element.fullName.toLowerCase().contains(value),
                                                                orElse: () =>
                                                                    model = PlantTypeModel.empty("value", "value"),
                                                              )
                                                            : null
                                                      });
                                              _typeAheadController.text = model.commonName;
                                              rebuild();
                                            },
                                            icon: const Icon(Icons.camera_alt)))),
                                suggestionsCallback: (pattern) {
                                  List<PlantTypeModel> t = [];
                                  t.addAll(widget.listTypes);
                                  t.retainWhere((element) =>
                                      element.commonName.toLowerCase().contains(pattern.toLowerCase()) ||
                                      element.fullName.toLowerCase().contains(pattern.toLowerCase()));
                                  return t;
                                },
                                itemBuilder: (context, PlantTypeModel suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.commonName ?? ""),
                                    subtitle: Text(suggestion.fullName ?? ""),
                                  );
                                },
                                onSuggestionSelected: (PlantTypeModel suggestion) {
                                  _typeAheadController.text = suggestion.commonName ?? "";
                                  model = suggestion;
                                },
                                validator: (value) {
                                  if (value == "" || value == null || model.id == 0) {
                                    return 'Please select a plant';
                                  }
                                  return null;
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
                                  },
                                  validator: (value) {
                                    DateFormat format = DateFormat("yyyy-MM-dd");
                                    if (value == "" || value == null) {
                                      return "Select a Date";
                                    }
                                    try {
                                      format.parseStrict(value);
                                    } catch (e) {
                                      return "Date must be yyyy-MM-dd";
                                    }

                                    return null;
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
                              const Text(
                                "with a nickname",
                                style: mainHeaderStyle,
                              ),
                              spacer,
                              TextFormField(
                                controller: _nicknameController,
                              ),
                              spacer,
                              const Text(
                                "with some notes",
                                style: mainHeaderStyle,
                              ),
                              spacer,
                              TextFormField(
                                controller: _descController,
                              ),
                              spacer,
                              SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await widget.api
                                              .addPlant(model.id, _nicknameController.text, _descController.text);
                                          Navigator.of(context).pop;
                                        }
                                      },
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
