class PlantTypeModel {
  int id;
  String commonName;
  String fullName; // This is the SCIENTIFIC NAME
  String type;

  PlantTypeModel.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        commonName = json['commonName'],
        fullName = json['fullName'],
        type = json['type'];

  PlantTypeModel.empty(String common, String science)
      : id = 0,
        commonName = common,
        fullName = science,
        type = "";
}
