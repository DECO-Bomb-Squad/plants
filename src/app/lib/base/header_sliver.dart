import 'package:app/api/plant_api.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:get_it/get_it.dart';

List<Widget> StandardHeaderBuilder(BuildContext context, bool innerBoxIsScrolled) {
  return <Widget>[
    SliverAppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop())),
      backgroundColor: lightColour,
      shadowColor: lightColour,
      pinned: false,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      iconTheme: const IconThemeData(color: darkHighlight, size: 35),
      actions: [
        IconButton(onPressed: () => GetIt.I<PlantAPI>().logout(), icon: const Icon(Icons.exit_to_app)),
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Add new entry',
          onPressed: () {/* ... */},
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Add new entry',
          onPressed: () {/* ... */},
        ),
      ],
    ),
  ];
}
