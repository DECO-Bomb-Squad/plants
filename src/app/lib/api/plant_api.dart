import 'dart:convert';
import 'dart:io';

import 'package:app/api/storage.dart';
import 'package:app/base/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//final AsyncCache<T> _getXCache = AsyncCache(const Duration(days: 1));

// Must refer to 10.0.2.2 within emulator - 127.0.0.1 refers to the emulator itself!
const BACKEND_URL_LOCAL = "http://10.0.2.2:5000";
const BACKEND_URL_PROD = "TODO_fill_in_later";

class PlantAPI {
  static final PlantAPI _instance = PlantAPI._internal();

  PlantAPI._internal();

  factory PlantAPI() => _instance;

  final _baseAddress = kReleaseMode ? BACKEND_URL_PROD : BACKEND_URL_LOCAL;

  PlantAppStorage store = PlantAppStorage();
  PlantAppCache cache = PlantAppCache();

  Uri makePath(String subPath, {Map<String, dynamic>? queryParams}) =>
      Uri.https(_baseAddress, subPath, queryParams ?? {});

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

  // Use this when you're querying the back end for a model to display on front end.
  // Constructor is generally going to be a model.fromJSON() constructor that creates
  // a model from the response body.
  // Not useful if you need to POST something or do something complex with the response
  Future<T?> getGeneric<T>(String path, T Function(dynamic) constructor, {String? key}) async {
    if (!await initUserIfRequired()) return null;

    http.Response response;
    try {
      response = await http.get(makePath(path), headers: header);
    } on Exception catch (e, st) {
      print(e);
      print(st);
      return null;
    }
    return response.statusCode == 200 ? (json.decode(response.body)) : null;
  }
}
