import 'dart:html';

import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';

import 'package:app/base/header_sliver.dart'; // notifications?

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // to add -> a back button?
  bool isSelected = true;
  List<DropdownMenuItem> exampleDropDown = <DropdownMenuItem>[]; // might need to add stuff here lol

  @override
  Widget build(BuildContext context) => Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: StandardHeaderBuilder,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "SETTINGS",
                style: mainHeaderStyle,
              ),
            ),
            spacer,
            Switch(value: isSelected, onChanged: ((value) => !isSelected)), // example switch
            spacer,
            DropdownButton(items: exampleDropDown, onChanged: ((value) => value = value)), // example drop down
            spacer,
            // add button
            ElevatedButton(
                onPressed: () => {
                      // example button
                      // idk button does something lmao add it here
                    },
                child: const Text("yes the button did something") // another thing to change
                ),
          ]),
        ),
      ));
  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
