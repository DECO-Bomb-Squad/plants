import 'package:flutter/material.dart';
import 'package:app/utils/colour_scheme.dart';

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