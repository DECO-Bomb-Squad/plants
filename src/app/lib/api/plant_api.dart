import 'dart:convert';
import 'dart:io';

import 'package:app/api/storage.dart';
import 'package:app/base/user.dart';
import 'package:app/interfaces/plant_type_info/plant_type_info_model.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/plantinstance/test_call.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

//final AsyncCache<T> _getXCache = AsyncCache(const Duration(days: 1));

// Must refer to 10.0.2.2 within emulator - 127.0.0.1 refers to the emulator itself!
const BACKEND_URL_LOCAL = "10.0.2.2:3000";
const BACKEND_URL_PROD = "TODO_fill_in_later";

const AZURE_BLOB_CONN_STR =
    "DefaultEndpointsProtocol=https;AccountName=bombsquadaloe;AccountKey=GASDIh22FSLmouUeAGYLRThOBdmkBiTr06yDPuVNu8jPUdPw7Nh7M86Af3xBNTd5l5HbcjRZHt48+AStbaK+ew==;EndpointSuffix=core.windows.net";

class PlantAPI {
  static final PlantAPI _instance = PlantAPI._internal();

  PlantAPI._internal();

  factory PlantAPI() => _instance;

  final _baseAddress = BACKEND_URL_LOCAL;
  // final _baseAddress = BACKEND_URL_LOCAL;
  //final _baseAddress = kReleaseMode ? BACKEND_URL_PROD : BACKEND_URL_LOCAL;

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

  Future<PlantTypeInfoModel> getPlantTypeInfo(String plantTypeName) {
    Map<String, String> queryParams = {"plant_type_name": plantTypeName};
    return getGeneric('test_plant', (j) => PlantTypeInfoModel.fromJSON(j));
  }

  PlantTypeInfoModel getPlantTypes(String plantTypeName) {
    return PlantTypeInfoModel.fromJSON(
        {"plant_name": "Rose", "scientific_name": "Scientific", "tags": [], "imageUrls": []});
  }

  Future<PlantInfoModel> getPlantInfo(int id) =>
      cache.plantInfoCache.putIfAbsent(id, () => AsyncCache(const Duration(days: 1))).fetch(() => _getPlantInfo(id));

  Future<PlantInfoModel> _getPlantInfo(int id) {
    Map<String, dynamic> testJson = jsonDecode(rawJson)[id];
    PlantInfoModel model = PlantInfoModel.fromJSON(testJson);
    return Future.delayed(const Duration(seconds: 1), () => model);
  }

  // Future<PlantImageGalleryModel> getPlantGallery(int id) {
  //   Map<String, dynamic> testJson = jsonDecode(galleryJson)[id];
  //   PlantImageGalleryModel model = PlantImageGalleryModel.fromJSON(testJson);
  //   return Future.delayed(const Duration(seconds: 1), () => model);
  // }
}
