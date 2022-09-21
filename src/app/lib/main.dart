import 'package:app/api/plant_api.dart';
import 'package:app/api/storage.dart';
import 'package:app/base/root_widget.dart';
import 'package:app/base/user.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';

void main() {
  runPlantApp();
}

void runPlantApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TEMP: until we begin properly initialising users w/ login, etc
  PlantAPI api = PlantAPI();
  api.user = User.fromJSON({
    "id": 1,
    "name": "Jay Son",
    "plantIds": [101, 102, 103, 104],
  });
  GetIt.I.registerSingleton<PlantAppStorage>(PlantAppStorage());
  GetIt.I.registerSingleton<PlantAppCache>(PlantAppCache());
  GetIt.I.registerSingleton<PlantAPI>(api);

  runApp(const PlantApp());
}

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: lightColour, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
    ); // This ensures that the phones status bar is the same colour as the app background and the icons are visible
    return MaterialApp(
      title: 'Plant App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: lightColour, // This sets the default background colour of the app
      ),
      home: const RootWidget(),
    );
  }
}
