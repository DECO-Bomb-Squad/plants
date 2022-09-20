import 'package:app/plantinstance/plant_info_model.dart';
import 'package:flutter/material.dart';

class EditPlantCareProfile extends ChangeNotifier {
  int? id;
  LocationType? location;
  SoilType? soilType;
  int? daysBetweenWatering;
  int? daysBetweenFertilising;
  int? daysBetweenRepotting;

  EditPlantCareProfile.fromEmpty();
  EditPlantCareProfile.fromProfile(PlantCareProfile profile) {
    id = profile.id;
    location = profile.location;
    soilType = profile.soilType;
    daysBetweenWatering = profile.daysBetweenWatering;
    daysBetweenFertilising = profile.daysBetweenFertilising;
    daysBetweenRepotting = profile.daysBetweenRepotting;
  }
}
