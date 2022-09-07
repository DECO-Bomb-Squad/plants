import 'dart:convert';

import 'package:app/forum/test_call.dart';
import 'package:app/screens/post_screen.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/forum/post_model.dart';
import 'package:flutter/material.dart';

class PostSmallWidget extends StatefulWidget {
  const PostSmallWidget({Key? key}) : super(key: key);

  @override
  State<PostSmallWidget> createState() => _PostSmallState();
}

class _PostSmallState extends State<PostSmallWidget> {
  @override
  Widget build(BuildContext context) {
    PostInfoModel model = PostInfoModel.fromJSON(jsonDecode(rawJSON));
    return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PostScreen(1)));
      },
      child: DecoratedBox(
        decoration: smallPostComponent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.title, style: sectionHeaderStyle),
                    Text("${model.author} - ${model.getReadableTimeAgo()} ago", style: modalTextStyle)
                    ],
                  )
              ),
              const Expanded(
                flex: 1,
                child: Icon(Icons.check_circle, size: 50)  
              )
            ],
          ),
        )
      )
    );
  }
}

class MakePostWidget extends StatelessWidget {
  const MakePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         ElevatedButton(
          onPressed: () {
          },
          style: buttonStyle,
          child: const Text("Post", style: buttonTextStyle),
        ),
        ElevatedButton(
          onPressed: () {
          },
          style: buttonStyle,
          child: const Text("Save as draft", style: buttonTextStyle),
        ),
      ],
    );
  }
}