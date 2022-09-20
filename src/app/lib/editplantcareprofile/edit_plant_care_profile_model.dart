import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

class EditPlantCareProfileModel extends ChangeNotifier {
  int id;
  LocationType location;
  SoilType soilType;

  int daysBetweenWatering;
  int daysBetweenFertilising;
  int daysBetweenRepotting;

  EditPlantCareProfileModel.fromJSON(Map<String, dynamic> json)
}
