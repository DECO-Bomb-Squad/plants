import 'package:app/api/plant_api.dart';
import 'package:app/base/user.dart';
import 'package:app/screens/add_plant/add_plant_screen.dart';
import 'package:app/screens/create_post_screen.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/forum/post.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = GetIt.I<PlantAPI>().user!;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "MY PLANTS",
                  style: mainHeaderStyle,
                )),
            IconButton(
              onPressed: () => (Navigator.of(context, rootNavigator: false)
                  .push(MaterialPageRoute(builder: (context) => PlantAddEmpty()))).then((value) => setState((() {}))),
              style: buttonStyle,
              icon: const Icon(Icons.add),
            )
          ]),
          spacer,
          SizedBox(
            height: 160,
            child: Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: user.ownedPlantIDs!.isEmpty
                  ? const Text("Add a plant to get started...", style: modalTextStyle)
                  : GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20),
                      children: user.ownedPlantIDs!.map((id) => PlantInfoEmpty(id, isSmall: true)).toList(),
                    ),
            ),
          ),
          spacer,
          spacer,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("HOT QUESTIONS", style: mainHeaderStyle),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePostScreen()));
              },
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
                  children: List<Widget>.generate(10, (int idx) => const PostSmallWidget()))),
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
