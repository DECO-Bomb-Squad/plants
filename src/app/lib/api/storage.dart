import 'package:app/interfaces/plant_type_info/plant_type_info_model.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantAppStorage {
  final Future<SharedPreferences> _store = SharedPreferences.getInstance();

  static final PlantAppStorage _instance = PlantAppStorage._internal();

  PlantAppStorage._internal();

  factory PlantAppStorage() {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance;
  }

  Future<String?> get(String key) async => (await _store).getString(key);

  Future<bool> has(String key) async => (await _store).containsKey(key);

  Future<void> remove(String key) async {
    SharedPreferences prefs = await _store;
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
    }
  }

  Future<void> clear() async => await (await _store).clear();

  Future<void> set(String key, String value) async => await (await _store).setString(key, value);
}

class PlantAppCache {
  static final PlantAppCache _instance = PlantAppCache._internal();

  PlantAppCache._internal();

  factory PlantAppCache() => _instance;

  Map<String, AsyncCache<PlantTypeInfoModel>> plantTypeInfoCache = {};

  Map<int, AsyncCache<PlantInfoModel>> plantInfoCache = {};

  Future<void> clear() async {
    // If you add a new cache to this class, be sure to invalidate it in here!
    plantTypeInfoCache.forEach((key, value) => value.invalidate());
  }
}
