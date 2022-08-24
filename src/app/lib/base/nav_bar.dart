import 'package:app/utils/colour_scheme.dart';
import 'package:flutter/material.dart';

// Placed here to easily allow changing of multiple instances of each at once
Color selected = lightColour;
Color unselected = darkHighlight;

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

  Widget getTab(bool isSelected) => Tab(text: text, icon: Icon(iconData, color: isSelected ? selected : unselected));
}

class NavBar extends StatefulWidget {
  final List<NavBarItem> items;
  final TabController controller;

  const NavBar({required this.controller, required this.items, super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            color: lightHighlight,
            boxShadow: [BoxShadow(color: Color.fromARGB(61, 48, 39, 33), blurRadius: 3, spreadRadius: 1)]),
        child: TabBar(
          indicatorColor: selected,
          controller: widget.controller,
          labelColor: selected,
          unselectedLabelColor: unselected,
          tabs: widget.items.asMap().entries.map((e) => e.value.getTab(widget.controller.index == e.key)).toList(),
        ),
      );
}
