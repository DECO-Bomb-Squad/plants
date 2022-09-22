import 'dart:math';

import 'package:app/forum/comment_model.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/reply_post_screen.dart';

class CommentManager {
  final BuildContext context;
  final int postID; // The ID of the post to get comments from
  CommentManagerModel model;

  CommentManager(this.context, this.postID, {Key? key})
      : model = CommentManagerModel(postID);

  void loadComments(List<Map<String, dynamic>> json) {
    // This should be making an API call, but for now JSON is fine
    for (var comment in json) {
      model.comments.add(CommentModel.fromJSON(comment));
    }
  }

  Column getComments() {
    Column output = Column(crossAxisAlignment: CrossAxisAlignment.center,);

    for (CommentModel comment in model.comments) {
      output.children.add(_getComment(comment));
    }

    return output;
  }
  
  Column _getComment(CommentModel comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded (
              flex: 1,
              child: Icon(Icons.account_circle, size: 40,)
            ),
            Expanded (
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${comment.authorID}", style: subheaderStyle),
                  Text(comment.getReadableTimeAgo())
                ],
              )
            )
          ]
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Icon(Icons.arrow_upward),
                  Text("${comment.score}", style: textStyle,),
                  Icon(Icons.arrow_downward)
                ],
              )
            ),
            Expanded(
              flex: 4,
              child: Text(comment.content)
            )
          ]
        ),
        Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: Column(
                //children: List<Widget>.generate(Random().nextInt(5), (e) => _getCommentReply()),
                children: comment.replies.map((e) => _getCommentReply(e)) as List<Widget>,
              )
            )
          ],
        ),
        _getReplyButton()
      ],
    );
  }

  Widget _getCommentReply(CommentModel reply) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded (
              flex: 1,
              child: Icon(Icons.account_circle, size: 40,)
            ),
            Expanded (
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Username", style: subheaderStyle),
                  Text("15 minutes ago")
                ],
              )
            )
          ]
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: const [
                  Icon(Icons.arrow_upward),
                  Text("20", style: textStyle,),
                  Icon(Icons.arrow_downward)
                ],
              )
            ),
            const Expanded(
              flex: 4,
              child: Text(
              "dfjklskdfsj ksdjhfksdhjfksjdh fkjsdh f kjshdfjk hsdjkfh sdjkfh skdjf ksjdhf ksjdhf kjs dfk hsd kfjh sdkjfh skejdh fiksh j"
              )
            )
          ]
        ),
      ],
    );
  }

  Widget _getReplyButton() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReplyPostScreen(1)));
            },
            style: smallButtonStyle,
            child: const Text("Write a response...", style: smallButtonTextStyle)
          )
        )
      ]
    );
  }
}