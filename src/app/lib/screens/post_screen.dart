
import 'package:app/forum/comment_model.dart';
import 'package:app/forum/post.dart';
import 'package:app/forum/post_model.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/plantinstance/plant_info.dart';
import 'package:app/forum/comments.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/screens/reply_post_screen.dart';


class PostScreen extends StatefulWidget {
  CommentManager? commentManager;
  PostInfoModel model;

  PostScreen(this.model, {Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    widget.commentManager = CommentManager(context, widget.model, addComment);
    widget.commentManager!.loadComments(widget.model.comments);
  }

  void addComment(CommentModel comment) {
    widget.commentManager!.addComment(comment);
    setState(() {widget.model.comments;});
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        scrollBehavior: const MaterialScrollBehavior(),
        headerSliverBuilder: StandardHeaderBuilder,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [   
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(child: Text(widget.model.title, style: mainHeaderStyle)),                          
                        const Icon(Icons.question_answer, size: 40,)
                      ],
                    ),
                  ),
                  // --- TAGS COMPONENT - Disabled as not crucial for MVP ---
                  // SizedBox(  
                  //   height: 40,
                  //   child: ListView.builder(
                  //     itemCount: 10,
                  //     scrollDirection: Axis.horizontal,
                  //     controller: ScrollController(),
                  //     itemBuilder: ((context, index) => tagItemBuilder(context, index))            
                  //   )
                  // ),
                  PostVoteComponent(widget.model.score)
                ]
              ),
              spacer,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.model.content, style: textStyle,)
              ),
              SizedBox(
                height: 160,
                child: Scrollbar(
                  thickness: 10,
                  thumbVisibility: false,
                  radius: const Radius.circular(10),
                  child: widget.model.attachedPlants.isNotEmpty ? GridView(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160, childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20),
                    children:
                      widget.model.attachedPlants.map((p) => PlantInfoEmpty(p["plantId"], isSmall: true)).toList(),
                  )
                  : spacer,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReplyPostScreen(widget.model, null, widget.commentManager!.model, addComment)));
                      },
                      style: buttonStyle,
                      child: const Text("Write a response...", style: buttonTextStyle)
                    )
                  ],
                )
              ),
              widget.commentManager!.getComments()
            ]
          )
        )
      )
    );
  }
}

SizedBox get spacer => const SizedBox(height: 20, width: 10); // TODO: Hacky, remove