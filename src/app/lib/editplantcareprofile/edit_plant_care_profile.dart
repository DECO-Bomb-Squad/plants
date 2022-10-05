import 'package:app/plantinstance/plant_info_model.dart';
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
    if (model.isNew) {
      submitText = "Create";
    }

    bool editMode = true;
    if (!model.wasInitiallyAssigned && !model.isNew) {
      editMode = false;
    }
    bool editModeInitialBool = editMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.5),
        decoration: dialogComponent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: (Column(
                children: [
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
                  TextFormField(
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
                  TextFormField(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: buttonStyle,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Discard", style: buttonTextStyle),
                ),
                ElevatedButton(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
