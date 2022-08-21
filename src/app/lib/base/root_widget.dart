import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootWidget extends StatefulWidget {
  RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  List<Widget> navItems = [];

  _RootWidgetState();

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [],
          ),
        ),
      );
}
