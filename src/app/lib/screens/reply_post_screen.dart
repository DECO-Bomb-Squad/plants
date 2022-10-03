import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/forum/post.dart';

class ReplyPostScreen extends StatefulWidget {
  final int postID;
  const ReplyPostScreen(this.postID, {Key? key}) : super(key: key);

  @override
  State<ReplyPostScreen> createState() => _ReplyPostScreenState();
}

class _ReplyPostScreenState extends State<ReplyPostScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: StandardHeaderBuilder,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: 
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - (padding * 2),
              child: Padding (
                padding: EdgeInsets.all(padding),
                child: Text("Existing question/comment, blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ", style: textStyle)
              )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: 
                DecoratedBox(
                  decoration: inputComponent,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Write your response here. Make sure to include plenty of detail...", style: inputStyle,)
                      ],
                    ),
                  )
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