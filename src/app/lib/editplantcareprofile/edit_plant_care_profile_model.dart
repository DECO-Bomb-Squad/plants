import 'package:app/plantinstance/plant_info_model.dart';
import 'package:flutter/material.dart';

class EditPlantCareProfileModel extends ChangeNotifier {
  int? id;
  LocationType? location;
  SoilType? soilType;
  int? daysBetweenWatering;
  int? daysBetweenFertilising;
  int? daysBetweenRepotting;
  bool isNew;
  bool wasInitiallyAssigned;
  PlantInfoModel? assignedPlant;

  EditPlantCareProfileModel.fromEmpty()
      : isNew = true,
        wasInitiallyAssigned = false;
  EditPlantCareProfileModel.fromProfile(PlantCareProfile profile, PlantInfoModel? plant)
      : id = profile.id,
        location = profile.location,
        soilType = profile.soilType,
        daysBetweenWatering = profile.daysBetweenWatering,
        daysBetweenFertilising = profile.daysBetweenFertilising,
        daysBetweenRepotting = profile.daysBetweenRepotting,
        isNew = false,
        assignedPlant = plant,
        wasInitiallyAssigned = plant == null ? false : true; // if plant null, false, if plant, true
}
