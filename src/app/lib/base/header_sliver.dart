import 'package:app/api/plant_api.dart';
import 'package:app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:get_it/get_it.dart';

List<Widget> StandardHeaderBuilder(BuildContext context, bool innerBoxIsScrolled,
    {bool hasBackButton = true, bool hasLogout = false}) {
  return <Widget>[
    SliverAppBar(
      automaticallyImplyLeading: false, // Prevents an implicit back button from rendering
      leading: hasBackButton
        ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop()))
        : null,
      backgroundColor: lightColour,
      shadowColor: lightColour,
      title: //hasBackButton
      //     ? null
      //     : 
      const Image(
              image: AssetImage('assets/head.png'),
              height: 35,
            ),
      pinned: false,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      iconTheme: const IconThemeData(color: accent, size: 35),
      actions: [
        if (hasLogout)
          IconButton(
              onPressed: () {
                GetIt.I<PlantAPI>().logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.exit_to_app)),
      ],
    ),
  ];
}
