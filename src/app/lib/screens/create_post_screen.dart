import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/forum/comments.dart';
import 'package:app/base/header_sliver.dart';

class CreatePostScreen extends StatefulWidget {
  final int id;
  const CreatePostScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: StandardHeaderBuilder,
      body: Text("Test")
    )
  );
}