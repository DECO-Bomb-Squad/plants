
import 'package:app/api/plant_api.dart';
import 'package:app/forum/post_model.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:flutter/material.dart';
import 'package:app/forum/tags.dart';
import 'package:app/base/header_sliver.dart';
import 'package:get_it/get_it.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final double padding = 15.0;
  Map<int, bool> userPlants = {};

  Map<int, bool> getUserPlants() {
    return userPlants;
  }

  void putUserPlants(Map<int, bool> newPlants) {
    userPlants = newPlants;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - (padding * 2),
            child: Padding (
              padding: EdgeInsets.all(padding),
              child: TextField(
                  controller: titleController, 
                  style: textStyle, 
                  decoration: titleInputComponent,
                  minLines: 1,
                  maxLines: null,
                  )
            ),
          ),
          // SizedBox(    --- TAGS - Disabled due to time constraints ---
          //   height: MediaQuery.of(context).size.height * 0.15,
          //   width: MediaQuery.of(context).size.width - (padding * 2),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [ 
          //       const Text("Tags", style: sectionHeaderStyle),
          //       SizedBox(
          //         height: 40,
          //         child: ListView.builder(
          //           itemCount: 10,
          //           scrollDirection: Axis.horizontal,
          //           controller: ScrollController(),
          //           itemBuilder: ((context, index) => tagItemBuilder(context, index))            
          //         )
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
            width: MediaQuery.of(context).size.width - (padding * 2),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: (() {
                    showDialog(context: context, builder: (_) => SelectPlantDialog(getUserPlants, putUserPlants));
                  }), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [Text("Attach plants/photos", style: buttonTextStyle)],
                  )
                )
              ]
            ) 
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [TextField(
                  controller: textController, 
                  style: textStyle, 
                  decoration: postInputComponent,
                  minLines: 6,
                  maxLines: null,
                  )
                ],
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  userPlants.removeWhere((key, value) => value == false);
                  GetIt.I<PlantAPI>().addPost(PostInfoModel(GetIt.I<PlantAPI>().user!.id, GetIt.I<PlantAPI>().user!.username, titleController.text, textController.text, userPlants.keys.toList()));
                  titleController.clear();
                  textController.clear();
                },
                style: buttonStyle,
                child: const Text("Post", style: buttonTextStyle),
              ),
            ],
          )
        ]
      )
    )
    
  );
}

class SelectPlantDialog extends StatefulWidget {
  Function userPlants;
  Function putPlants;
  SelectPlantDialog(this.userPlants, this.putPlants, {super.key});

  @override
  State<SelectPlantDialog> createState() => _SelectPlantState();
}

class _SelectPlantState extends State<SelectPlantDialog> {
  List<Widget> plantCheckboxes = [];
  final Map<int, bool> _userPlants = {};

  @override
  void initState() {
    super.initState();

    for(int id in GetIt.I<PlantAPI>().user!.ownedPlantIDs!) {
      if (widget.userPlants().containsKey(id) && widget.userPlants()[id]) {
        _userPlants[id] = true;
      } else {
        _userPlants[id] = false;
      }
    }
  }

  void rebuild() {
    setState(() {
      _userPlants;
    });

    widget.putPlants(_userPlants);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, 
      child: Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 1.5,
          ),
          decoration: dialogComponent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: GetIt.I<PlantAPI>().user!.ownedPlantIDs!.map((id) => 
              LoadingBuilder(
                GetIt.I<PlantAPI>().getPlantInfo(id), 
                (m) =>
                  CheckboxListTile(
                    title: Text((m as PlantInfoModel).nickName ?? m.plantName),
                    subtitle: Text(m.description ?? ""),
                    secondary: m.getCoverPhoto(40, 40, Icons.grass, 20),
                    activeColor: accent,
                    checkColor: accent,
                    value: _userPlants[id], 
                    onChanged: (bool? result) {
                      _userPlants[id] = result!;
                      rebuild();
                    }
                  )
                )
              ).toList()
            )
          )
        ),
      );
  }
}