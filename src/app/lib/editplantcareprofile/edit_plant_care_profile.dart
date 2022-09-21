import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';

class EditPlantCareProfile extends StatefulWidget {
  const EditPlantCareProfile({super.key});

  @override
  State<EditPlantCareProfile> createState() => _EditPlantCareProfileState();
}

class _EditPlantCareProfileState extends State<EditPlantCareProfile> {
  var model = EditPlantCareProfileModel.fromEmpty(); // TODO: model = existing model
  bool isEmpty = true; // added this to prevent initialising controller text as the toString of null

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _daysBetweenWateringController = TextEditingController();
  final TextEditingController _daysBetweenFertilisingController = TextEditingController();
  final TextEditingController _daysBetweenRepottingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!isEmpty) {
      _idController.text = model.id.toString();
      _locationController.text = model.location.toString();
      _soilTypeController.text = model.soilType.toString();
      _daysBetweenWateringController.text = model.daysBetweenWatering.toString();
      _daysBetweenFertilisingController.text = model.daysBetweenFertilising.toString();
      _daysBetweenRepottingController.text = model.daysBetweenRepotting.toString();
    }
    //TODO: add listeners? _controller.addListener(_function to update the model)
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
                    controller: _idController,
                    validator: (String? value) {
                      // check for int
                    },
                  )
                ],
              )),
            )
            // row for submit and discard buttons
          ],
        ),
      ),
    );
  }
}
