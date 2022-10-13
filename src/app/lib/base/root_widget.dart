import 'package:app/base/header_sliver.dart';
import 'package:app/base/nav_bar.dart';
import 'package:app/screens/create_post_screen.dart';
import 'package:app/screens/my_plants_screen.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/screens/layout_test_screen.dart';
import 'package:flutter/material.dart';

import '../screens/post_screen.dart';

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
        childFunc: () => const MainScreen(),
      ),
      NavBarItem(
        text: "My Plants",
        iconData: Icons.yard,
        childFunc: () => const MyPlantsScreen(),
      ),
      NavBarItem(
        text: "Trending",
        iconData: Icons.trending_up,
        childFunc: () => const LayoutScreen("Demo time!"),
      ),
      NavBarItem(
        text: "Ask\nQuestion",
        iconData: Icons.question_answer,
        childFunc: () => const CreatePostScreen(),
      ),
    ];
    controller = TabController(length: navItems!.length, vsync: this);
  }

  List<NavBarItem>? navItems;

  TabController? controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) =>
                StandardHeaderBuilder(context, isScrolled, hasBackButton: false, hasLogout: true),
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
