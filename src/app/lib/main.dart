import 'package:app/api/plant_api.dart';
import 'package:app/api/storage.dart';
import 'package:app/base/root_widget.dart';
import 'package:app/base/user.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
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
    "userId": 1,
    "username": "Jay Son",
    "email": "email@plantnet.com",
    "reputation": 0,
    "bio": "skill issue",
    "plantIds": [101, 102, 103, 104],
  });
  bool loggedIn = await api.initUserFromStorage();
  GetIt.I.registerSingleton<PlantAPI>(api);

  await Firebase.initializeApp();

  runApp(PlantApp(loggedIn));
}

class PlantApp extends StatelessWidget {
  final bool loggedIn;

  const PlantApp(this.loggedIn, {super.key});

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
        scaffoldBackgroundColor: lightColour, // This sets the default background colour of the app
        primaryColor: accent,
      ),
      home: loggedIn ? const RootWidget() : const LoginScreen(),
    );
  }
}
