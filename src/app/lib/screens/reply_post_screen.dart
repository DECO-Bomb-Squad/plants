import 'dart:convert';

import 'package:app/api/plant_api.dart';
import 'package:app/base/user.dart';
import 'package:app/editplantcareprofile/edit_plant_care_profile.dart';
import 'package:app/forum/comment_model.dart';
import 'package:app/forum/post_model.dart';
import 'package:app/forum/test_post.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/base/header_sliver.dart';
import 'package:get_it/get_it.dart';

class ReplyPostScreen extends StatefulWidget {
  final PostInfoModel model;
  final int? parentID;
  CommentManagerModel commentModel;
  Function returnFunction;
  ReplyPostScreen(this.model, this.parentID, this.commentModel, this.returnFunction, {Key? key}) : super(key: key);

  @override
  State<ReplyPostScreen> createState() => _ReplyPostScreenState();
}

class _ReplyPostScreenState extends State<ReplyPostScreen> {
  final TextEditingController textController = TextEditingController();

  PlantCareProfile? attached;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  void onAttachPressed() async {
    PlantCareProfile? newProfile = await showDialog<PlantCareProfile?>(
        context: context, builder: (_) => EditPlantCareProfile(profile: attached, plant: null));
    setState(() {
      attached = newProfile;
    });
  }

  Widget get attachPlantCareProfileSection {
    String buttonText = attached != null ? "View attached care profile" : "Attach care profile";
    return ElevatedButton(
      onPressed: onAttachPressed,
      style: buttonStyle,
      child: Text(buttonText, style: buttonTextStyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: StandardHeaderBuilder,
            body: Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width - (padding * 2),
                      child: Padding(
                        padding: const EdgeInsets.only(top: padding, bottom: padding * 3),
                        child: DecoratedBox(
                          decoration: quoteComponent,
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Text(widget.model.content, style: textStyle),
                          ),
                        ),
                      )),
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
                  attachPlantCareProfileSection,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          User user = GetIt.I<PlantAPI>().user!;
                          CommentModel newComment = CommentModel(user.id, widget.parentID, widget.model.postID,
                              textController.text, GetIt.I<PlantAPI>().user!.username, attached);
                          await GetIt.I<PlantAPI>().addComment(newComment);
                          widget.returnFunction(newComment);
                          // setState(() {widget.model!.comments;});
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
                  )
                ]))));
  }
}
