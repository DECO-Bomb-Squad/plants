import 'package:app/api/plant_api.dart';
import 'package:app/base/user.dart';
import 'package:app/screens/add_plant/add_plant_screen.dart';
import 'package:app/screens/create_post_screen.dart';
import 'package:app/utils/colour_scheme.dart';
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
  Widget build(BuildContext context) { 
    GetIt.I<PlantAPI>().refreshPosts(5);
    setState(() {
      context;
    });
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                const Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Text("MY PLANTS", style: mainHeaderStyle),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: IconButton(
                    onPressed: () => (Navigator.of(context, rootNavigator: false)
                        .push(MaterialPageRoute(builder: (context) => PlantAddEmpty()))).then((value) => setState((() {}))),
                    style: buttonStyle,
                    icon: const Icon(Icons.add, size: 30),
                  )
                )  
              ]
            ),
          ),
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
            child: RefreshIndicator(
              color: accent,
              onRefresh: () {
                GetIt.I<PlantAPI>().refreshPosts(5);
                return Future.sync(() {
                  setState(() {
                    context;
                  });
                });
              },
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: GetIt.I<PlantAPI>().recentPosts!.map((id) => PostSmallEmpty(id, false)
                ).toList()
              ),
            )
            
          )
        ],
      ));
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
