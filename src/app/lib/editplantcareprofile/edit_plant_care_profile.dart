import 'package:flutter/material.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile_model.dart';

class EditPlantCareProfile extends StatefulWidget {
  final EditPlantCareProfileModel model;

  const EditPlantCareProfile(this.model, {super.key});

  @override
  State<EditPlantCareProfile> createState() => _EditPlantCareProfileState();
}

class _EditPlantCareProfileState extends State<EditPlantCareProfile> {
  @override
  Widget build(BuildContext context) {
    return Dialog(); // threw this here to stop error. TODO: replace with the widget
  }
}
