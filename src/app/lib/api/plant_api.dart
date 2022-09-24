import 'dart:convert';
import 'dart:io';
import 'package:app/screens/add_plant/plant_type_model.dart';
import 'package:dio/dio.dart';

import 'package:app/api/storage.dart';
import 'package:app/base/user.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/plantinstance/test_call.dart';
import 'package:app/screens/add_plant/plant_identification_screen.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

//final AsyncCache<T> _getXCache = AsyncCache(const Duration(days: 1));

// Must refer to 10.0.2.2 within emulator - 127.0.0.1 refers to the emulator itself!
const BACKEND_URL_LOCAL = "10.0.2.2:3000";
const BACKEND_URL_PROD = "https://peclarke.pythonanywhere.com/";

const AZURE_BLOB_CONN_STR =
    "DefaultEndpointsProtocol=https;AccountName=bombsquadaloe;AccountKey=GASDIh22FSLmouUeAGYLRThOBdmkBiTr06yDPuVNu8jPUdPw7Nh7M86Af3xBNTd5l5HbcjRZHt48+AStbaK+ew==;EndpointSuffix=core.windows.net";

const PLANTNET_API_KEY = "2b10EBekKsq2B9XbUDp0bzwEO";
const PLANTNET_URL = "https://my-api.plantnet.org/v2/identify/all?api-key=";

class PlantAPI {
  static final PlantAPI _instance = PlantAPI._internal();

  PlantAPI._internal();

  factory PlantAPI() => _instance;

  // IMPORTANT! use local if the pythonanywhere deployment doesn't match what the front end model expects!
  // Change this "false" to a "true" to use prod deployment
  final _baseAddress = true ? BACKEND_URL_PROD : BACKEND_URL_LOCAL;

  PlantAppStorage store = PlantAppStorage();
  PlantAppCache cache = PlantAppCache();

  Uri makePath(String subPath, {Map<String, dynamic>? queryParams}) =>
      Uri.http(_baseAddress, subPath, queryParams ?? {});

  User? user;

  Map<String, String> get header => {HttpHeaders.userAgentHeader: user!.id.toString()};

  Future<bool> initialise() async {
    if (user == null) {
      return initUserIfRequired();
    }
    return true;
  }

  static const String user_store_name = "user_details";

  // Returns true if user could be constructed
  // Returns false if login is required
  Future<bool> initUserIfRequired() async {
    if (user == null) {
      if (await store.has(user_store_name)) {
        // We have user details stored, extract them and initialise the user
        String userDetails = (await store.get(user_store_name))!;
        Map<String, dynamic> decodedUserDetails = jsonDecode(userDetails);
        user = User.fromJSON(decodedUserDetails);
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<void> setUserData(Map<String, dynamic> data) async {
    await store.set(user_store_name, jsonEncode(data["user"]));
    user = User.fromJSON(data["user"]);
  }

  Future<bool> login(String username) async {
    http.Response response;
    try {
      response = await http.get(makePath('/login', queryParams: {"username": username}));
    } on Exception catch (e, st) {
      print(e);
      print(st);
      return false;
    }

    if (response.statusCode == 200) {
      await setUserData(json.decode(response.body));
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await store.clear();
    cache.clear();
  }

  Future<T> getGeneric<T>(String path, T Function(dynamic) constructor, {Map<String, dynamic>? queryParams}) async {
    if (!await initUserIfRequired()) throw Exception("User not initialised!");

    http.Response response = await http.get(makePath(path, queryParams: queryParams), headers: header);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode.toString());
    }
    return constructor(json.decode(response.body));
  }

  Future<List<PlantTypeModel>> getPlantTypes() async {
    http.Response response;
    try {
      response = await http.get(makePath('/planttype'));
    } on Exception catch (e, st) {
      print(e);
      print(st);
      return [];
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      List<PlantTypeModel> types = [for (Map<String, dynamic> t in result['plantTypes']) PlantTypeModel.fromJSON(t)];
      types.sort((a, b) => a.commonName.compareTo(b.commonName));
      return types;
    } else {
      return [];
    }
  }

  Future<List<IdentifyResult>> getPlantNetResults(List<PlantIdentifyModel> samples) async {
    var dio = Dio();
    var formData = FormData();
    formData.fields.addAll([for (PlantIdentifyModel s in samples) MapEntry("organs", s.organ)]);
    formData.files
        .addAll([for (PlantIdentifyModel s in samples) MapEntry("images", MultipartFile.fromFileSync(s.image))]);
    var response = await dio.post(PLANTNET_URL + PLANTNET_API_KEY, data: formData);
    List<IdentifyResult> identify = [];
    for (Map<String, dynamic> r in response.data["results"]) {
      identify.add(IdentifyResult(r["species"]["scientificNameWithoutAuthor"], r["score"]));
    }
    return identify;
  }

  Future<PlantInfoModel> getPlantInfo(int id) =>
      cache.plantInfoCache.putIfAbsent(id, () => AsyncCache(const Duration(days: 1))).fetch(() => _getPlantInfo(id));

  Future<PlantInfoModel> _getPlantInfo(int id) {
    String path = "/plant/$id";
    return getGeneric(path, (result) => PlantInfoModel.fromJSON(result));
  }

  Future<bool> addPlantPhoto(String imageURL, int plantId) async {
    String path = "/plant/photos/add";

    http.Response response =
        await http.post(makePath(path), headers: header, body: {"plantId": plantId.toString(), "uri": imageURL});

    return response.statusCode == 200;
  }

  Future<bool> removePlantPhoto(String imageURL) async {
    String path = "/plant/photos/remove";

    http.Response response = await http.delete(makePath(path), headers: header, body: {"uri": imageURL});

    return response.statusCode == 200;
  }

  Future<bool> addPlantActivity(DateTime day, ActivityTypeId type, int plantId) async {
    String path = "/activity";

    http.Response response = await http.post(makePath(path),
        headers: header,
        body: {'plantId': plantId.toString(), 'activityTypeId': type.index.toString(), 'time': day.toIso8601String()});

    return response.statusCode == 200;
  }

  Future<bool> addWatering(DateTime day, int plantId) => addPlantActivity(day, ActivityTypeId.watering, plantId);
  Future<bool> addRepotting(DateTime day, int plantId) => addPlantActivity(day, ActivityTypeId.repotting, plantId);
  Future<bool> addFertilising(DateTime day, int plantId) => addPlantActivity(day, ActivityTypeId.fertilising, plantId);
}
