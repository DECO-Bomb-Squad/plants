// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:app/forum/comment_model.dart';
import 'package:app/screens/add_plant/plant_type_model.dart';
import 'package:dio/dio.dart';

import 'package:app/api/storage.dart';
import 'package:app/base/user.dart';
import 'package:app/forum/post_model.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/secrets.dart';
import 'package:app/screens/add_plant/plant_identification_screen.dart';
import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

//final AsyncCache<T> _getXCache = AsyncCache(const Duration(days: 1));

// Must refer to 10.0.2.2 within emulator - 127.0.0.1 refers to the emulator itself!
const BACKEND_URL_LOCAL = "10.0.2.2:3000";
const BACKEND_URL_PROD = "peclarke.pythonanywhere.com";

const PLANTNET_URL = "https://my-api.plantnet.org/v2/identify/all?api-key=";

class PlantAPI {
  static final PlantAPI _instance = PlantAPI._internal();

  PlantAPI._internal();

  factory PlantAPI() => _instance;

  // IMPORTANT! use local if the pythonanywhere deployment doesn't match what the front end model expects!
  // Change this "false" to a "true" to use prod deployment
  final _baseAddress = true ? BACKEND_URL_PROD : BACKEND_URL_LOCAL;

  // Storage and caching objects
  PlantAppStorage store = PlantAppStorage();
  PlantAppCache cache = PlantAppCache();

  // Firebase messaging instance, for sending and receiving notifications.
  FirebaseMessaging fbMessaging = FirebaseMessaging.instance;

  // Connects a subpath with the main server uri
  Uri makePath(String subPath, {Map<String, dynamic>? queryParams}) =>
      Uri.http(_baseAddress, subPath, queryParams ?? {});

  User? user;
  List<int>? recentPosts;

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
        user!.ownedPlantIDs = await getUserPlants(user!.username);
        recentPosts = await _getRecentPosts(5);
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  // Handles user json sent by back end - Adds to local device storage and sets up the user object singleton
  Future<User> setUserData(Map<String, dynamic> data) async {
    await store.set(user_store_name, jsonEncode(data));
    user = User.fromJSON(data);
    user!.ownedPlantIDs = await getUserPlants(user!.username);
    recentPosts = await _getRecentPosts(5);
    return user!;
  }

  void refreshPosts(int i) async {
    recentPosts = await _getRecentPosts(i);
  }

  Future<bool> login(String username) async {
    String path = "/users/$username";
    http.Response response;
    try {
      response = await http.get(makePath(path), headers: header);
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
    user = null;
  }

  // Generic way to create a model by accessing a uri.
  Future<T> getGeneric<T>(String path, T Function(dynamic) constructor, {Map<String, dynamic>? queryParams}) async {
    http.Response response = await http.get(makePath(path, queryParams: queryParams), headers: header);
    if (response.statusCode != 200) {
      throw Exception(response.statusCode.toString());
    }
    return constructor(json.decode(response.body));
  }

  // Retrieves a list of plant types
  Future<List<PlantTypeModel>> getPlantTypes() async {
    http.Response response;
    try {
      response = await http.get(makePath('/planttypes'), headers: header);
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

  // Pl@ntNet api requires us to make requests in a different format to normal :(
  // This retrieves a list of species that match the samples (images) we pass in
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

  // Adds a plant to the database
  Future<PlantInfoModel?> addPlant(int plantTypeId, String name, String description) async {
    http.Response response;
    try {
      response = await http.post(makePath('/plant'), headers: header, body: {
        "userId": user?.id.toString(),
        "plantTypeId": plantTypeId.toString(),
        "desc": description,
        "personalName": name
      });
    } on Exception catch (e, st) {
      print(e);
      print(st);
      return null;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      PlantInfoModel m = PlantInfoModel.fromJSON(result);
      user?.ownedPlantIDs?.add(m.id);
      cache.plantInfoCache.putIfAbsent(m.id, () => AsyncCache(const Duration(days: 1)));
    } else {
      return null;
    }
    return null;
  }

  // Retrieves all info about a plant
  // This method uses caching to reduce network load - will load from local cache if possible
  Future<PlantInfoModel> getPlantInfo(int id) =>
      cache.plantInfoCache.putIfAbsent(id, () => AsyncCache(const Duration(days: 1))).fetch(() => _getPlantInfo(id));

  Future<PlantInfoModel> _getPlantInfo(int id) {
    String path = "/plant/$id";
    return getGeneric(path, (result) => PlantInfoModel.fromJSON(result));
  }

  // Retrieves all info about a post
  Future<PostInfoModel> getPostInfo(int id) {
    String path = "/forum/post/$id";
    return getGeneric(path, (result) => PostInfoModel.fromJSON(result));
  }

  // Retrieves a list of ids of recent posts
  Future<List<int>> _getRecentPosts(int num) async {
    String path = "/forum/post/list/$num";
    //return getGeneric(path, (result) => PostInfoModel.fromJSON(result));

    http.Response response = await http.get(makePath(path), headers: header);

    List<dynamic> res = jsonDecode(response.body)["posts"];
    return res.map((e) => e as int).toList();
  }

  // Adds a post to the database
  Future<bool> addPost(PostInfoModel model) async {
    String path = "/forum/post";

    http.Response response = await http.post(makePath(path), headers: header, body: {
      "userId": model.authorID.toString(),
      "title": model.title,
      "content": model.content,
      "plantIds": jsonEncode(model.attachedPlants),
      "tagIds": jsonEncode([])
    });

    return response.statusCode == 200;
  }

  // Adds a comment to the database
  Future<bool> addComment(CommentModel comment) async {
    String path = "/forum/comment";

    http.Response response = await http.post(makePath(path), headers: header, body: {
      "userId": comment.authorID.toString(),
      "content": comment.content,
      if (comment.parentID != null) "parentId": comment.parentID.toString(),
      if (comment.plantCareModel != null) "careProfileId": comment.plantCareModel!.id.toString(),
      "postId": comment.postID.toString()
    });

    return response.statusCode == 200;
  }

  // Updates the score of a comment
  Future<bool> updateCommentScore(CommentModel comment) async {
    String path = "/forum/comment/updatescore";

    http.Response response = await http.patch(makePath(path), headers: header, body: {
      "commentId": comment.commentID.toString(),
      "score": comment.score.toString(),
    });

    return response.statusCode == 200;
  }

  // Updates the score of a post
  Future<bool> updatePostScore(PostInfoModel post) async {
    String path = "/forum/post/updatescore";

    http.Response response = await http.patch(makePath(path), headers: header, body: {
      "postId": post.postID.toString(),
      "score": post.score.toString(),
    });

    return response.statusCode == 200;
  }

  // Adds a plant photo to the database
  Future<bool> addPlantPhoto(String imageURL, int plantId) async {
    String path = "/plant/photos/add";

    http.Response response =
        await http.post(makePath(path), headers: header, body: {"plantId": plantId.toString(), "uri": imageURL});

    return response.statusCode == 200;
  }

  // Removes a plant photo from the database
  Future<bool> removePlantPhoto(String imageURL) async {
    String path = "/plant/photos/remove";

    http.Response response = await http.delete(makePath(path), headers: header, body: {"uri": imageURL});

    return response.statusCode == 200;
  }

  // Adds a plant activity - watering, repotting or fertilising
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

  // Gets a list of ids of plants belonging to the current user
  Future<List<int>> getUserPlants(String username) async {
    String path = "/users/$username/plants";

    http.Response response = await http.get(makePath(path), headers: header);

    List<dynamic> res = json.decode(response.body);
    return res.map((e) => e as int).toList();
  }

  // Posts firebase messaging token to back end to be used for current user
  Future<bool> postTokenForUser(String token, String username) async {
    String path = "/users/$username/token";

    http.Response response = await http.post(makePath(path), headers: header, body: {"token": token});

    return response.statusCode == 200;
  }

  // Updates a plant's care profile
  Future<bool> updatePlantCareProfile(PlantCareProfile profile) async {
    String path = "/careprofile/update";
    Map<String, dynamic> reqBody = {
      "careProfileId": profile.id.toString(),
      "soilType": profile.soilType.name,
      "plantLocation": profile.location.name,
      "daysBetweenWatering": profile.daysBetweenWatering.toString(),
      "daysBetweenRepotting": profile.daysBetweenRepotting.toString(),
      "daysBetweenFertilizer": profile.daysBetweenFertilising.toString(),
    };

    http.Response response = await http.patch(makePath(path), body: reqBody, headers: header);

    return response.statusCode == 200;
  }

  // Posts a new orphaned plantcareprofile for the forum
  Future<PlantCareProfile?> createPlantCareProfile(PlantCareProfile profile) async {
    String path = "/careprofile/add";
    Map<String, dynamic> reqBody = {
      "soilType": profile.soilType.name,
      "plantLocation": profile.location.name,
      "daysBetweenWatering": profile.daysBetweenWatering.toString(),
      "daysBetweenRepotting": profile.daysBetweenRepotting.toString(),
      "daysBetweenFertilizer": profile.daysBetweenFertilising.toString()
    };

    http.Response response = await http.post(makePath(path), body: reqBody, headers: header);
    if (response.statusCode != 200) {
      return null;
    }

    Map<String, dynamic> res = json.decode(response.body);
    int? profileId = res["id"];
    profile.id = profileId!;

    return profile;
  }
}
