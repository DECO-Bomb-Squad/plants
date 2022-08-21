import 'package:app/base/nav_bar.dart';
import 'package:app/demo/demo_widget.dart';
import 'package:flutter/material.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget>
    with SingleTickerProviderStateMixin {
  _RootWidgetState();

  @override
  void initState() {
    super.initState();
    navItems = [
      NavBarItem(
        text: "Demo",
        iconData: Icons.question_answer,
        childFunc: () => DemoWidget("Demo! Hello"),
      ),
      NavBarItem(
        text: "Second Thing",
        iconData: Icons.two_k,
        childFunc: () => const Text("boo"),
      ),
    ];
    controller = TabController(length: navItems!.length, vsync: this);
  }

  List<NavBarItem>? navItems;

  TabController? controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: NavBar(
            controller: controller!,
            items: navItems!,
          ),
        ),
        body: TabBarView(
          controller: controller!,
          children: navItems!.map((e) => e.child).toList(),
        ),
      );
}
