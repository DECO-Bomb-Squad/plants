import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  final String demoTitle;
  const LayoutScreen(this.demoTitle, {Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int counter;

  _LayoutScreenState() : counter = 0;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "HEADER 1\nExample text in mainHeaderStyle\n",
            style: mainHeaderStyle,
          ),
          Text(
            "HEADER 2\nExample text in sectionHeaderStyle\n",
            style: sectionHeaderStyle,
          ),
          Text(
            "HEADER 3\nExample text in subHeaderStyle\n",
            style: subheaderStyle,
          ),
          Text(
            "BODY TEXT\nExample text in textStyle\n",
            style: textStyle,
          ),
        ],
      ));

  // Can use getters like these to potentially do pretty complex operations, but still call it like its a class param!
  // class functions with no arguments are often better used as getters!
  // you can also define setters
  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
