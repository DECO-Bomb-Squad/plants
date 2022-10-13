import 'package:app/api/plant_api.dart';
import 'package:app/base/root_widget.dart';
import 'package:app/firebase_options.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialise the API singleton
  PlantAPI api = PlantAPI();
  // Firebase messaging setup, to enable device notifications
  api.fbMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: false);
  api.fbMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  // Try to automatically initialise user from stored user data
  bool loggedIn = await api.initUserFromStorage();
  if (loggedIn) {
    // Get firebase messaging token and send to server
    api.fbMessaging.getToken().then((token) {
      api.postTokenForUser(token!, api.user!.username);
    });
    api.fbMessaging.onTokenRefresh.listen((token) {
      api.postTokenForUser(token, api.user!.username);
    });
  }
  // Register API as singleton to be accessed anywhere
  GetIt.I.registerSingleton<PlantAPI>(api);

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
      title: 'Aloe',
      theme: ThemeData(
        canvasColor: Colors.transparent,
        backgroundColor: lightColour,
        scaffoldBackgroundColor: lightColour, // This sets the default background colour of the app
        primaryColor: accent,
      ),
      home: loggedIn ? const RootWidget() : const LoginScreen(),
    );
  }
}
