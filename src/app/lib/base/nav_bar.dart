import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

class NavBarItem {
  final String text;
  final IconData iconData;

  // use generator function to reduce initial load time
  final Widget Function() childFunc;
  Widget? _child;
  Widget get child {
    _child ??= childFunc();
    return _child ?? childFunc(); // dart complains about nullness unless i do this also
  }

  NavBarItem({required this.text, required this.iconData, required this.childFunc});

  Widget getTab(bool isSelected) =>
      Tab(text: text, icon: Icon(iconData, color: isSelected ? selectedIconColour : unselectedIconColour));
}

class NavBar extends StatefulWidget {
  List<NavBarItem> items;

  NavBar({required this.items, super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: widget.items.length, vsync: this);
    controller?.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
              child: TabBarView(
            controller: controller,
            children: widget.items.map((e) => e.child).toList(),
          )),
          Container(
            decoration: const BoxDecoration(color: navBarColour),
            child: TabBar(
              indicatorColor: selectedIconColour,
              controller: controller,
              labelColor: selectedIconColour,
              unselectedLabelColor: unselectedIconColour,
              tabs: widget.items.asMap().entries.map((e) => e.value.getTab(controller?.index == e.key)).toList(),
            ),
          ),
        ],
      );
}
