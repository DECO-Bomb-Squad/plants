import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/plantinstance/plant_info.dart';

import 'package:app/base/header_sliver.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: NestedScrollView(
          scrollDirection: Axis.vertical,
          scrollBehavior: const MaterialScrollBehavior(),
          headerSliverBuilder: StandardHeaderBuilder,
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    // image of user
                    Column(
                      // alignment stuff here
                      children: const [
                        Text(
                          "USER NAME",
                          style: mainHeaderStyle,
                        ),
                        Text("JOIN DATE"), // needs to be subheading or something
                      ], // placeholder text, not a const
                    )
                  ]),
                  spacer,
                  SizedBox(
                      // i stole this from post_screen
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Question title", style: mainHeaderStyle),
                          SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                  controller: ScrollController(),
                                  itemBuilder: ((context, index) => tagItemBuilder(context, index))))
                        ],
                      )),
                  spacer,
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("USER's PLANTS", style: mainHeaderStyle),
                  ),
                  spacer,
                  SizedBox(
                      // again i stole this from post_screen
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: GridView(
                          scrollDirection: Axis.horizontal,
                          controller: ScrollController(),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          children: List<Widget>.generate(2, (int idx) => PlantInfoEmpty(idx, isSmall: true)))),
                  // user setting screen?
                ],
              ))));
  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
