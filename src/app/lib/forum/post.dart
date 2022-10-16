import 'package:app/api/plant_api.dart';
import 'package:app/screens/post_screen.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:app/forum/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PostSmallEmpty extends StatefulWidget {
  final int postID;
  final bool showDesc;
  final Function returnFunc;
  final PlantAPI api = GetIt.I<PlantAPI>();

  PostSmallEmpty(this.postID, this.showDesc, this.returnFunc, {Key? key}) : super(key: key);

  @override 
  State<PostSmallEmpty> createState() => _PostSmallEmptyState();
}

class _PostSmallEmptyState extends State<PostSmallEmpty> {
  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: smallPostComponent,
        child: LoadingBuilder(
          widget.api.getPostInfo(widget.postID),
          (m) => PostSmallWidget(m as PostInfoModel, widget.showDesc, widget.returnFunc)
        )
      ),
    );
  }
}

class PostSmallWidget extends StatefulWidget {
  final PostInfoModel model;
  final bool showDesc;
  final Function returnFunc;
  const PostSmallWidget(this.model, this.showDesc, this.returnFunc, {Key? key}) : super(key: key);

  @override
  State<PostSmallWidget> createState() => _PostSmallState();
}

class _PostSmallState extends State<PostSmallWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => PostScreen(widget.model))).then(widget.returnFunc());
      },
      child: DecoratedBox(
        decoration: smallPostComponent,
        child: Column(
          children: [
            Padding(
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
                        Text(widget.model.title, style: sectionHeaderStyle),
                        Text("${widget.model.username} - ${widget.model.getReadableTimeAgo()} ago", style: modalTextStyle)
                        ],
                      )),
                  const Expanded(flex: 1, child: Icon(Icons.question_answer, size: 50))
                ],
              ),
            ),
            if (widget.showDesc) Padding(
              padding: EdgeInsets.all(8.0), 
              child: Text(widget.model.content, style: modalTextStyle,),) 
          ]
        ),
      ),
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
        decoration: BoxDecoration(
          color: darkColour, 
          borderRadius: BorderRadius.circular(radius)
        ),
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
                  color: (widget.voted == -1) ? negative : lightColour,
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
