import 'package:app/api/plant_api.dart';
import 'package:app/forum/post.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  Future<Null> rebuild() {
    GetIt.I<PlantAPI>().refreshPosts(5);
    return Future.sync(() {
      setState(() {
        context;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    rebuild();
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: RefreshIndicator(
            color: accent,
            onRefresh: rebuild,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Text("HOT QUESTIONS", style: mainHeaderStyle),
                    )
                  ]),
                ),
                Flexible(
                    child: ListView(
                        controller: ScrollController(),
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        children:
                            GetIt.I<PlantAPI>().recentPosts!.map((id) => PostSmallEmpty(id, true, rebuild)).toList()))
              ],
            )));
  }

  SizedBox get spacer => const SizedBox(height: 10, width: 10);
}
