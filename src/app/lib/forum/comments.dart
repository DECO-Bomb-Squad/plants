import 'package:app/api/storage.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile.dart';
import 'package:app/forum/comment_model.dart';
import 'package:app/forum/post_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/reply_post_screen.dart';

class CommentManager {
  final BuildContext context;
  final PostInfoModel postModel; // The ID of the post to get comments from
  PlantAppStorage store = PlantAppStorage();
  Function(CommentModel) returnFunction;
  CommentManagerModel model;

  CommentManager(this.context, this.postModel, this.returnFunction) : model = CommentManagerModel(postModel.postID);

  void loadComments(List<dynamic> json) {
    for (var comment in json) {
      model.comments.add(CommentModel.fromJSON(comment));
    }
  }

  void purgeComments() {
    model.comments = [];
  }

  void addComment(CommentModel comment) {
    if (comment.parentID != null) {
      for (CommentModel parent in model.comments) {
        if (parent.commentID == comment.parentID) {
          parent.replies.add(comment);
        }
      }
    } else {
      model.comments.add(comment);
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
        Row(children: [
          const Expanded(
              flex: 1,
              child: Icon(
                Icons.account_circle,
                size: 40,
              )),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${comment.username}", style: subheaderStyle),
                  Text("${comment.getReadableTimeAgo()} ago")
                ],
              ))
        ]),
        Row(children: [
          Expanded(flex: 1, child: CommentVoteComponent(comment, store)),
          Expanded(flex: 4, child: Text(comment.content))
        ]),
        if (comment.plantCareModel != null)
          Row(children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => EditPlantCareProfile(profile: comment.plantCareModel, plant: null));
                  },
                  style: careButtonStyle,
                  child: Flexible(
                    flex: 1,
                    child: const Text("View care profile", style: buttonTextStyle)
                    )
                  )
            )
          ]),
        Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 6,
                child: Column(
                  //children: List<Widget>.generate(Random().nextInt(5), (e) => _getCommentReply()),
                  children: List<Widget>.from(comment.replies.map((e) => _getCommentReply(e))),
                ))
          ],
        ),
        _getReplyButton(comment.commentID)
      ],
    );
  }

  Widget _getCommentReply(CommentModel comment) {
    return Column(
      children: [
        Row(children: [
          const Expanded(
              flex: 1,
              child: Icon(
                Icons.account_circle,
                size: 40,
              )),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${comment.username}", style: subheaderStyle),
                  Text("${comment.getReadableTimeAgo()} ago")
                ],
              ))
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Expanded(flex: 1, child: CommentVoteComponent(comment, store)),
          Expanded(flex: 4, child: Text(comment.content))
        ]),
        if (comment.plantCareModel != null)
        Row(children: [
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 14,
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => EditPlantCareProfile(profile: comment.plantCareModel, plant: null));
                },
                style: careButtonStyle,
                child: const Text("View care profile", style: buttonTextStyle)),
          )
        ]),
      ],
    );
  }

  Widget _getReplyButton(int? parent) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
          flex: 4,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReplyPostScreen(postModel, parent, model, returnFunction)));
              },
              style: buttonStyle,
              child: const Text("Write a response...", style: smallButtonTextStyle)))
    ]);
  }
}

class CommentVoteComponent extends StatefulWidget {
  final CommentModel comment;
  final PlantAppStorage storage;

  CommentVoteComponent(this.comment, this.storage, {super.key});

  @override
  State<CommentVoteComponent> createState() => _CommentVoteComponentState();
}

class _CommentVoteComponentState extends State<CommentVoteComponent> {
  int voted = 0; // Stores the vote "offset" i.e. +1 is an upvote, -1 is a downvote

  loadValues() async {
    if (await widget.storage.has(widget.comment.commentID.toString())) {
      voted = await widget.storage.get(widget.comment.commentID.toString()) as int;
      widget.comment.score += voted;
    }
    return true;
  }

  @override
  initState() {
    super.initState();

    loadValues();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            child: Icon(Icons.arrow_upward, color: (voted == 1) ? accent : darkColour),
            onTap: () async {
              if (voted != 1) {
                widget.comment.score += 1 - voted;
                voted = 1;
              } else {
                widget.comment.score -= 1;
                voted = 0;
              }
              await widget.storage.set(widget.comment.commentID.toString(), voted.toString());
              setState(() {
                voted;
              }); // Rebuild self
            }),
        Text(
          "${widget.comment.score}",
          style: textStyle,
        ),
        InkWell(
          child: Icon(Icons.arrow_downward, color: (voted == -1) ? negative : darkColour),
          onTap: () async {
            if (voted != -1) {
              widget.comment.score -= 1 + voted;
              voted = -1;
            } else {
              widget.comment.score += 1;
              voted = 0;
            }
            await widget.storage.set(widget.comment.commentID.toString(), voted.toString());
            setState(() {
              voted;
            }); // Rebuild self
          },
        )
      ],
    );
  }
}
