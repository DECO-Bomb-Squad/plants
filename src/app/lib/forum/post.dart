import 'dart:convert';

import 'package:app/forum/test_post.dart';
import 'package:app/screens/post_screen.dart';
import 'package:app/utils/colour_scheme.dart';
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
                    Text("${model.authorID} - ${model.getReadableTimeAgo()} ago", style: modalTextStyle)
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
            Navigator.pop(context);
          },
          style: buttonStyle,
          child: const Text("Post", style: buttonTextStyle),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: buttonStyle,
          child: const Text("Save as draft", style: buttonTextStyle),
        ),
      ],
    );
  }
}

class PostVoteComponent extends StatefulWidget {
  int voted = 0;
  int score;

  PostVoteComponent(this.score, {super.key}); 

  @override 
  State<PostVoteComponent> createState() => _PostVoteComponentState();
}

class _PostVoteComponentState extends State<PostVoteComponent> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DecoratedBox(
        decoration: voteComponent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: 
                Icon(Icons.arrow_upward, 
                color: (widget.voted == 1) ? accent : lightColour,
                size: 30,),
              onTap: () {
                if (widget.voted != 1) {
                  widget.score += 1 - widget.voted;
                  widget.voted = 1;
                } else {
                  widget.score -= 1;
                  widget.voted = 0;
                }
                setState(() {widget.voted;}); // Rebuild self
              } 
            ),
            Text("${widget.score}", style: tagTextStyle,),
            InkWell(
              child: 
                Icon(
                  Icons.arrow_downward,
                  color: (widget.voted == -1) ? accent : lightColour,
                  size: 30,
                ),
              onTap: () {
                if (widget.voted != -1) {
                  widget.score -= 1 + widget.voted;
                  widget.voted = -1;
                } else {
                  widget.score += 1;
                  widget.voted = 0;
                }
          
                setState(() {widget.voted;}); // Rebuild self
              },
            )
          ],
        ),
      ),
    );
  }
}