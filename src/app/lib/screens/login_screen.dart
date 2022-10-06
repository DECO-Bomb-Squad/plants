import 'package:app/api/plant_api.dart';
import 'package:app/base/root_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<bool> loggedInFuture;
  String? errorMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMessage != null) Text(errorMessage!),
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

  void onLoginClicked() async {
    String username = cont.text;
    PlantAPI api = GetIt.I<PlantAPI>();
    // Login makes API call and stores all user info in local storage.
    bool loginSuccess = await api.login(username);
    if (loginSuccess) {
      // Post the device token to the server to enable it to send notifications
      String? token = await api.fbMessaging.getToken();
      api.postTokenForUser(token!, username);
      // Navigate to the home screen now that we have the relevant user info
      navigateToHome();
    } else {
      // Display error message if user couldnt be logged in
      setState(() {
        errorMessage = "User $username not found!";
      });
    }
  }

  void navigateToHome() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootWidget()));
  }
}
