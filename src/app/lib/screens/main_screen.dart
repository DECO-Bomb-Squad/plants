import 'package:app/api/plant_api.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "MY PLANTS",
                style: mainHeaderStyle,
              )),
          spacer,
          SizedBox(
            height: 160,
            child: Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: GridView(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200, childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20),
                children:
                    GetIt.I<PlantAPI>().user!.ownedPlantIDs.map((id) => PlantInfoEmpty(id, isSmall: true)).toList(),
              ),
            ),
          ),
          spacer,
          spacer,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("HOT QUESTIONS", style: mainHeaderStyle),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => null,
            )
          ]),
          Flexible(
              child: GridView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.9,
                      childAspectRatio: 3 / 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  children: List<Widget>.generate(
                      10,
                      (int idx) => DecoratedBox(
                          decoration: smallPostComponent,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spacer,
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      questions[idx % 3],
                                      style: subheaderStyle,
                                    )),
                                spacer,
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      questionsFurther[idx % 3],
                                      style: textStyle,
                                    )),
                              ]))))),
        ],
      ));

  SizedBox get spacer => const SizedBox(height: 10, width: 10);

  List<String> get questions => const ["Lounge room cat", "Watering levels", "Does my plant hate me"];
  List<String> get questionsFurther => const [
        "My cat keeps attacking my fiddle leaf",
        "If I water my cactus everyday will it grow faster?",
        "The thorns on the stem keep attacking me and my family. What can I do?"
      ];
}
