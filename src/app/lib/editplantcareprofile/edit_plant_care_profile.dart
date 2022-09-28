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

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _daysBetweenWateringController = TextEditingController();
  final TextEditingController _daysBetweenFertilisingController = TextEditingController();
  final TextEditingController _daysBetweenRepottingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      model = EditPlantCareProfileModel.fromProfile(widget.profile!);
    } else {
      model = EditPlantCareProfileModel.fromEmpty();
    }
    _idController.text = model.id.toString();
    _locationController.text = model.location.toString();
    _soilTypeController.text = model.soilType.toString();
    _daysBetweenWateringController.text = model.daysBetweenWatering.toString();
    _daysBetweenFertilisingController.text = model.daysBetweenFertilising.toString();
    _daysBetweenRepottingController.text = model.daysBetweenRepotting.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _idController.dispose();
    _locationController.dispose();
    _soilTypeController.dispose();
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

    bool editMode = false;
    if (model.wasInitiallyAssigned) {
      editMode = true;
    }

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
                  TextFormField(
                    readOnly: editMode,
                    controller: _idController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || double.tryParse(value) == null) {
                        return 'Please enter a valid ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: editMode,
                    controller: _locationController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid location';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: editMode,
                    controller: _soilTypeController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid soil type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: editMode,
                    controller: _daysBetweenWateringController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: editMode,
                    controller: _daysBetweenFertilisingController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    readOnly: editMode,
                    controller: _daysBetweenRepottingController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              )),
              // plant assign here
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // navigator.ofcontext pop
                // discard -> pop widget USE TEXT BUTTON
                // submit -> json stuff ELEVATED BUTTONS print contents of model to console
                // model update method by passing profile in, changing values etc. use method

                const TextButton(
                  onPressed: null, // replace with discard
                  child: Text("Discard"),
                ),
                ElevatedButton(
                    onPressed: null, // replace with submit
                    child: Text(submitText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
