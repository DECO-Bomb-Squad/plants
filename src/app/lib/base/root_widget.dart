import 'package:app/base/nav_bar.dart';
import 'package:app/demo/demo_widget.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> with SingleTickerProviderStateMixin {
  _RootWidgetState();

  @override
  void initState() {
    super.initState();
    navItems = [
      NavBarItem(
        text: "Home",
        iconData: Icons.home,
        childFunc: () => const MainScreen("Demo! Hello"),
      ),
      NavBarItem(
        text: "My Plants",
        iconData: Icons.yard,
        childFunc: () => const Text("boo"),
      ),
      NavBarItem(
        text: "Trending",
        iconData: Icons.trending_up,
        childFunc: () => const Text("boo"),
      ),
      NavBarItem(
        text: "Ask\nQuestion",
        iconData: Icons.question_answer,
        childFunc: () => const Text("boo"),
      ),
    ];
    controller = TabController(length: navItems!.length, vsync: this);
  }

  List<NavBarItem>? navItems;

  TabController? controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: lightColour,
                  shadowColor: lightColour,
                  pinned: false,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  iconTheme: const IconThemeData(color: darkHighlight, size: 35),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Add new entry',
                      onPressed: () {/* ... */},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      tooltip: 'Add new entry',
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ];
            },
            body: TabBarView(
              controller: controller!,
              children: navItems!.map((e) => e.child).toList(),
            )),
        bottomNavigationBar: BottomAppBar(
          child: NavBar(
            controller: controller!,
            items: navItems!,
          ),
        ),
      );
}
