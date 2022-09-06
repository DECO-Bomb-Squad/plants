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
  @override
  Widget build(BuildContext context) => Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: StandardHeaderBuilder,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
        ),
      ));
}
