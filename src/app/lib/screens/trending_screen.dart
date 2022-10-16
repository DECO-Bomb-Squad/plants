import 'package:app/api/plant_api.dart';
import 'package:app/forum/post.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
        children: [
            SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: const [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Text("HOT QUESTIONS", style: mainHeaderStyle),
                )
              ]
            ),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.vertical,
              children: GetIt.I<PlantAPI>().recentPosts!.map((id) => PostSmallEmpty(id, true)
              ).toList()
            )
          )
        ],
      ));

  // Can use getters like these to potentially do pretty complex operations, but still call it like its a class param!
  // class functions with no arguments are often better used as getters!
  // you can also define setters
  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
