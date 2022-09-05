import 'package:app/screens/create_post_screen.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/forum/post.dart';

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
                      children: List<Widget>.generate(6, (int idx) => PlantInfoEmpty(idx, isSmall: true))))),
          spacer,
          spacer,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("HOT QUESTIONS", style: mainHeaderStyle),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreatePostScreen()));
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
                  children: List<Widget>.generate(10, (int idx) => PostSmallWidget()))),
        ],
      ));

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
