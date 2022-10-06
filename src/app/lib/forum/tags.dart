import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

tagItemBuilder(BuildContext context, int index) {
  return Column(
    children: [
      Padding(
          padding: const EdgeInsets.all(3.0),
          child: DecoratedBox(
              decoration: tagComponent,
              child: const Padding(padding: EdgeInsets.all(5), child: Text("Post tag", style: tagTextStyle))))
    ],
  );
}
