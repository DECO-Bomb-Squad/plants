import 'package:app/forum/comment_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/reply_post_screen.dart';
import 'package:loading_gifs/loading_gifs.dart';

class CommentManager {
  final BuildContext context;
  final int postID; // The ID of the post to get comments from
  CommentManagerModel model;

  CommentManager(this.context, this.postID, {Key? key})
      : model = CommentManagerModel(postID);

  void loadComments(List<dynamic> json) {
    // This should be making an API call, but for now JSON is fine
    for (var comment in json) {
      model.comments.add(CommentModel.fromJSON(comment));
    }
  }

  Column getComments() {
    List<Column> output = [];

    for (CommentModel comment in model.comments) {
      output.add(_getComment(comment));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: output);
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
                  Text("${comment.getReadableTimeAgo()} ago")
                ],
              )
            )
          ]
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CommentVoteComponent(comment.score)
            ),
            Expanded(
              flex: 4,
              child: Text(comment.content)
            )
          ]
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: null,
                style: buttonStyle,
                child: const Text("View care profile", style: buttonTextStyle)
              ),
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
                children: List<Widget>.from(comment.replies.map((e) => _getCommentReply(e))),
              )
            )
          ],
        ),
        _getReplyButton()
      ],
    );
  }

  Widget _getCommentReply(CommentModel comment) {
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
                children: [
                  Text("${comment.authorID}", style: subheaderStyle),
                  Text("${comment.getReadableTimeAgo()} ago")
                ],
              )
            )
          ]
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CommentVoteComponent(comment.score)
            ),
            Expanded(
              flex: 4,
              child: Text(comment.content)
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
              MaterialPageRoute(builder: (context) => ReplyPostScreen(1)));
            },
            style: smallButtonStyle,
            child: const Text("Write a response...", style: smallButtonTextStyle)
          )
        )
      ]
    );
  }
}

class CommentVoteComponent extends StatefulWidget {
  int voted = 0;
  int score;

  CommentVoteComponent(this.score, {super.key}); 

  @override 
  State<CommentVoteComponent> createState() => _CommentVoteComponentState();
}

class _CommentVoteComponentState extends State<CommentVoteComponent> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: 
            Icon(Icons.arrow_upward, color: (widget.voted == 1) ? accent : darkColour),
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
        Text("${widget.score}", style: textStyle,),
        InkWell(
          child: 
            Icon(Icons.arrow_downward, color: (widget.voted == -1) ? accent : darkColour
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
    );
  }
}