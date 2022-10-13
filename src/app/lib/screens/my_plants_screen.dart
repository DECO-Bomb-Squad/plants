import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/screens/add_plant/add_plant_screen.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  GestureDetector get addPlantsButton => GestureDetector(
      child: Center(
        child: Row(
          children: const [
            Text(
              "Add new plant",
              style: modalTextStyle,
            ),
            Icon(
              Icons.add,
              size: 20.0,
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context, rootNavigator: false)
          .push(MaterialPageRoute(builder: (context) => PlantAddEmpty()))
          .then((value) => setState(() {})));

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
              ),
            ),
            addPlantsButton,
            spacer,
            Flexible(
              child: GridView(
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.9,
                  childAspectRatio: 3 / 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: GetIt.I<PlantAPI>()
                    .user!
                    .ownedPlantIDs!
                    .map((int id) => PlantInfoEmpty(
                          id,
                          isSmall: false,
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      );

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
