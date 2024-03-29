import 'package:app/api/plant_api.dart';
import 'package:app/base/user.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';
import 'package:get_it/get_it.dart';

// Widget for editing a plant's care details
class EditPlantCareProfile extends StatefulWidget {
  PlantCareProfile? profile;
  PlantInfoModel? plant;

  bool stiflePlantDropdown;

  EditPlantCareProfile({super.key, required this.profile, required this.plant, this.stiflePlantDropdown = false});

  @override
  State<EditPlantCareProfile> createState() => _EditPlantCareProfileState();
}

class _EditPlantCareProfileState extends State<EditPlantCareProfile> {
  late EditPlantCareProfileModel model;
  late bool plantAssignable;

  late User user;
  List<PlantInfoModel> plants = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _daysBetweenWateringController = TextEditingController();
  final TextEditingController _daysBetweenFertilisingController = TextEditingController();
  final TextEditingController _daysBetweenRepottingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      model = EditPlantCareProfileModel.fromProfile(widget.profile!, widget.plant);
      _daysBetweenWateringController.text = model.daysBetweenWatering.toString();
      _daysBetweenFertilisingController.text = model.daysBetweenFertilising.toString();
      _daysBetweenRepottingController.text = model.daysBetweenRepotting.toString();
    } else {
      model = EditPlantCareProfileModel.fromEmpty();
    }
    plantAssignable = !widget.stiflePlantDropdown && model.assignedPlant == null;

    PlantAPI api = GetIt.I<PlantAPI>();
    user = api.user!;
    for (int plantID in user.ownedPlantIDs!) {
      api.getPlantInfo(plantID).then((PlantInfoModel plant) => plants.add(plant)).then((value) => setState(() {}));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _daysBetweenWateringController.dispose();
    _daysBetweenFertilisingController.dispose();
    _daysBetweenRepottingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String submitText = "Save";
    String discardText = "Discard";
    String titleText = "EDIT CARE PROFILE";
    if (model.isNew) {
      submitText = "Create";
      titleText = "CREATE CARE PROFILE";
    }

    bool editMode = true;
    if (!model.wasInitiallyAssigned && !model.isNew) {
      editMode = false;
      titleText = "ASSIGN CARE PROFILE";
    }

    if (widget.stiflePlantDropdown && !model.isNew) {
      discardText = "OK";
      titleText = "VIEW CARE PROFILE";
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.2),
          decoration: dialogComponent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(titleText, style: sectionHeaderStyle),
              Form(
                key: _formKey,
                child: (Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(children: [
                        DropdownButton<SoilType>(
                          value: model.soilType,
                          dropdownColor: lightColour,
                          onChanged: (SoilType? newType) {
                            setState(() {
                              model.soilType = newType;
                            });
                          },
                          items: SoilType.values.map((SoilType soilType) {
                            return DropdownMenuItem<SoilType>(
                              value: soilType,
                              child: Text(soilType.toHumanString()!),
                            );
                          }).toList(),
                        ),
                        DropdownButton<LocationType>(
                          value: model.location,
                          dropdownColor: lightColour,
                          onChanged: (LocationType? newLocation) {
                            setState(() {
                              model.location = newLocation;
                            });
                          },
                          items: LocationType.values.map((LocationType location) {
                            return DropdownMenuItem<LocationType>(
                              value: location,
                              child: Text(location.toHumanString()!),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Days Between Watering:",
                            hintText: "Type a number...",
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenWateringController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! < 1) {
                              return 'Please enter a valid number';
                            } else {
                              model.daysBetweenWatering = int.parse(value);
                              return null;
                            }
                          },
                        ),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Days Between Fertilising:",
                            hintText: "Type a number...",
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenFertilisingController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || double.tryParse(value)! < 1) {
                              return 'Please enter a valid number';
                            } else {
                              model.daysBetweenFertilising = int.parse(value);
                              return null;
                            }
                          },
                        ),
                        spacer,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Days Between Repotting:",
                            hintText: "Type a number...",
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenRepottingController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || double.tryParse(value)! < 1) {
                              return 'Please enter a valid number';
                            } else {
                              model.daysBetweenRepotting = int.parse(value);
                              return null;
                            }
                          },
                        ),
                      ]),
                    ),
                    if (plantAssignable)
                      Column(
                        children: [
                          Text("Assign to plant:", style: modalTextStyle),
                          DropdownButton<PlantInfoModel>(
                            value: model.assignedPlant,
                            onChanged: (PlantInfoModel? plant) {
                              setState(() {
                                model.assignedPlant = plant;
                              });
                              editMode = plant == null ? false : true;
                            },
                            items: plants
                                .map((p) => DropdownMenuItem(
                                      child: Text(p.nickName ?? p.plantName),
                                      value: p,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                  ],
                )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // check this
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: (TextButton(
                        style: buttonStyle,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(discardText, style: buttonTextStyle),
                      )),
                    ),
                    if (!widget.stiflePlantDropdown || model.isNew)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                PlantCareProfile? profileToReturn;
                                if (model.isNew) {
                                  PlantCareProfile newProfile = PlantCareProfile.newCareProfile(model);
                                  profileToReturn = await GetIt.I<PlantAPI>().createPlantCareProfile(newProfile);
                                } else {
                                  await model.assignedPlant?.careProfile.updatePlantCareProfile(model);
                                  profileToReturn = model.assignedPlant?.careProfile;
                                }
                                Navigator.of(context).pop<PlantCareProfile?>(profileToReturn);
                              }
                            },
                            child: Text(submitText, style: buttonTextStyle)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
