import 'dart:convert';

import 'package:app/forum/post_model.dart';
import 'package:app/forum/test_post.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/forum/post.dart';

class ReplyPostScreen extends StatefulWidget {
  final int postID;
  ReplyPostScreen(this.postID, {Key? key}) : super(key: key);

  @override
  State<ReplyPostScreen> createState() => _ReplyPostScreenState();
}

class _ReplyPostScreenState extends State<ReplyPostScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostInfoModel model = PostInfoModel.fromJSON(jsonDecode(rawJSON));
  
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: StandardHeaderBuilder,
        body: Padding(
          padding: const EdgeInsets.all(padding),
          child: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - (padding * 2),
                child: Padding(
                  padding: const EdgeInsets.only(top: padding, bottom: padding * 3),
                  child: DecoratedBox(
                    decoration: quoteComponent,
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(model.content, style: textStyle),
                    ),
                  ),
                )
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: textController, 
                    style: textStyle, 
                    decoration: replyInputComponent,
                    minLines: 2,
                    maxLines: null,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.width - (padding * 2),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Attach plants/photos", style: sectionHeaderStyle)
                  ]
                ) 
              ),
              const MakePostWidget()
            ]
          )
        )
      )
    );
  }
}