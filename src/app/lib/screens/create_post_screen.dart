import 'package:app/forum/post.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/base/header_sliver.dart';

class CreatePostScreen extends StatefulWidget {

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final double padding = 15.0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: StandardHeaderBuilder,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - (padding * 2),
              child: Padding (
                padding: EdgeInsets.all(padding),
                child: Text("Write a descriptive title...", style: inputTitleStyle)
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width - (padding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  Text("Tags", style: sectionHeaderStyle),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      controller: ScrollController(),
                      itemBuilder: ((context, index) => tagItemBuilder(context, index))            
                    )
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Write your question here. Make sure to include plenty of detail...", style: inputStyle,)
                  ],
                ),
              )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width - (padding * 2),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Attach plants/photos", style: sectionHeaderStyle)
                ]
              ) 
            ),
            MakePostWidget()
          ]
        )
      )
    )
  );
}