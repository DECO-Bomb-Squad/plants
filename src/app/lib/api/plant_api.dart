import 'dart:convert';
import 'dart:io';

import 'package:app/api/storage.dart';
import 'package:app/base/user.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/secrets.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

//final AsyncCache<T> _getXCache = AsyncCache(const Duration(days: 1));

// Must refer to 10.0.2.2 within emulator - 127.0.0.1 refers to the emulator itself!
const BACKEND_URL_LOCAL = "10.0.2.2:3000";
const BACKEND_URL_PROD = "peclarke.pythonanywhere.com";

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

  // Auth token - back end rejects requests that don't use this header for security reasons
  Map<String, String> get header => {"apiKey": API_KEY};

  Future<bool> initialise() async {
    if (user == null) {
      return initUserFromStorage();
    }
    return true;
  }

  static const String user_store_name = "user_details";

  // Returns true if user could be constructed
  // Returns false if login is required
  Future<bool> initUserFromStorage() async {
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

  // Handles user json sent by back end - Adds to local device storage and sets up the user object singleton
  Future<void> setUserData(Map<String, dynamic> data) async {
    await store.set(user_store_name, jsonEncode(data));
    user = User.fromJSON(data);
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
    http.Response response = await http.get(makePath(path, queryParams: queryParams), headers: header);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode.toString());
    }
    return constructor(json.decode(response.body));
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

  Future<List<int>> getUserPlants(String username) async {
    String path = "/users/$username/plants";

    http.Response response = await http.get(makePath(path), headers: header);

    List<dynamic> res = json.decode(response.body);
    return res.map((e) => e as int).toList();
  }
}
