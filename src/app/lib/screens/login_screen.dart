import 'package:app/api/plant_api.dart';
import 'package:app/base/root_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<bool> loggedInFuture;

  @override
  void initState() {
    super.initState();
    // Returns false if user info was not in device's local storage
    loggedInFuture = GetIt.I<PlantAPI>().initUserFromStorage();
    loggedInFuture.then((bool loggedIn) {
      if (loggedIn) {
        navigateToHome();
      }
    });
  }

  void navigateToHome() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootWidget()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (token != null) Text(token!),
            usernameField,
            submitButton,
          ],
        ),
      );

  TextEditingController cont = TextEditingController();

  Widget get usernameField => TextFormField(
        controller: cont,
        decoration: const InputDecoration(labelText: "Enter username", hintText: "Username"),
      );

  Widget get submitButton => ElevatedButton(
        onPressed: onLoginClicked,
        child: const Text("Log in"),
      );

  String? token;

  void onLoginClicked() async {
    String username = cont.text;
    PlantAPI api = GetIt.I<PlantAPI>();
    await api.login(username);
    token = await api.fbMessaging.getToken();
    setState(() {});
    print(token);
    print(api.user!.id);
  }
}
