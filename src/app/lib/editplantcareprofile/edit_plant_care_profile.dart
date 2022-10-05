import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';

class EditPlantCareProfile extends StatefulWidget {
  PlantCareProfile? profile;
  EditPlantCareProfile({super.key, this.profile});

  @override
  State<EditPlantCareProfile> createState() => _EditPlantCareProfileState();
}

class _EditPlantCareProfileState extends State<EditPlantCareProfile> {
  late EditPlantCareProfileModel model;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _daysBetweenWateringController = TextEditingController();
  final TextEditingController _daysBetweenFertilisingController = TextEditingController();
  final TextEditingController _daysBetweenRepottingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      model = EditPlantCareProfileModel.fromProfile(widget.profile!);
      _daysBetweenWateringController.text = model.daysBetweenWatering.toString();
      _daysBetweenFertilisingController.text = model.daysBetweenFertilising.toString();
      _daysBetweenRepottingController.text = model.daysBetweenRepotting.toString();
    } else {
      model = EditPlantCareProfileModel.fromEmpty();
    }
    model.soilType ??= SoilType.smallPot;
    model.location ??= LocationType.indoor; // defaults if new plant
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
    String titleText = "SAVE CARE PROFILE";
    if (model.isNew) {
      submitText = "Create";
      titleText = "CREATE CARE PROFILE";
    }

    bool editMode = true;
    if (!model.wasInitiallyAssigned && !model.isNew) {
      editMode = false;
      titleText = "ASSIGN CARE PROFILE";
    }
    bool editModeInitialBool = editMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.5),
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
                          value: model.soilType!,
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
                          value: model.location!,
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenWateringController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || double.tryParse(value) == null) {
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenFertilisingController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null) {
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accent),
                            ),
                            labelStyle: const TextStyle(
                              color: darkColour,
                            ),
                          ),
                          controller: _daysBetweenRepottingController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            } else {
                              model.daysBetweenRepotting = int.parse(value);
                              return null;
                            }
                          },
                        ),
                      ]),
                    ),
                    Container(
                      child: editModeInitialBool == false
                          ? DropdownButton<PlantInfoModel>(
                              // not sure what type should be will need to sort out
                              value: null,
                              items: null, // get user plants
                              onChanged: (PlantInfoModel? plant) {
                                setState(() {
                                  // update value with plant info
                                  model.assignedPlant = plant;
                                });
                                editMode = plant == null ? false : true;
                              },
                            )
                          : null,
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
                        child: const Text("Discard", style: buttonTextStyle),
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: editMode == false
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    // create new plant
                                    model.assignedPlant?.careProfile.updatePlantCareProfile(model);
                                    Navigator.of(context).pop();
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
