import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/screens/add_plant/plant_type_model.dart';
import 'package:app/screens/add_plant/plant_identification_screen.dart';
import 'package:app/utils/loading_builder.dart';
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

class _PlantAddScreenState extends State<PlantAddScreen> {
  String soil = "small pot";
  PlantTypeModel model = PlantTypeModel.empty("", "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _typeAheadController.text = model.fullName;
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
                  title: const Text("Add Plant", style: mainHeaderStyle),
                  centerTitle: true,
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
                                child: TypeAheadFormField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: _typeAheadController,
                                    decoration: InputDecoration(
                                      labelText: 'Plant',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => PlantIdentificationDialog(
                                                    validSciNames: widget.listTypes.map((t) => t.fullName).toList(),
                                                  )).then((value) => {
                                                value != null
                                                    ? setState(
                                                        (() => model = widget.listTypes.firstWhere(
                                                            (element) => element.fullName.toLowerCase().contains(value),
                                                            orElse: () => model = PlantTypeModel.empty("", ""))),
                                                      )
                                                    : null
                                              });
                                          _typeAheadController.text = model.commonName;
                                          rebuild();
                                        },
                                        icon: const Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ),
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
                                ),
                              ),
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
                                minLines: 1,
                                maxLines: 5,
                              ),
                              spacer,
                              spacer,
                              SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate() && model.id != 0) {
                                          PlantInfoModel? result = await widget.api
                                              .addPlant(model.id, _nicknameController.text, _descController.text);
                                          Navigator.of(context).pop();
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
