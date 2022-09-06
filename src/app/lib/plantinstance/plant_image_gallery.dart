import 'dart:io';

import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_image_gallery_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/image_gallery.dart';
import 'package:app/utils/loading_builder.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:azblob/azblob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class PlantGalleryEmpty extends StatefulWidget {
  final int plantID;
  final PlantAPI api = GetIt.I<PlantAPI>();
  PlantGalleryEmpty(this.plantID, {super.key});

  @override
  State<PlantGalleryEmpty> createState() => _PlantGalleryEmptyState();
}

class _PlantGalleryEmptyState extends State<PlantGalleryEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: smallPlantComponent,
      child: LoadingBuilder(
        widget.api.getPlantGallery(widget.plantID),
        (m) => PlantGalleryScreen(widget.plantID, m as PlantImageGalleryModel),
      ),
    );
  }
}

class PlantGalleryScreen extends StatefulWidget {
  final int plantID;
  final PlantImageGalleryModel model;

  const PlantGalleryScreen(this.plantID, this.model, {super.key});

  @override
  State<PlantGalleryScreen> createState() => _PlantGalleryScreenState();
}

class _PlantGalleryScreenState extends State<PlantGalleryScreen> {
  String blobLink = "blob";

  Future<Uint8List?> getImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;
    return image.readAsBytes();
  }

  void doStuffWithImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    Uint8List imgBytes = await image.readAsBytes();
    var storage = AzureStorage.parse(AZURE_BLOB_CONN_STR);
    String path = "/images/${image.name}";
    await storage.putBlob(
      path,
      bodyBytes: imgBytes,
    );
    blobLink = (await storage.getBlobLink(path)).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop())),
              backgroundColor: lightColour,
              shadowColor: lightColour,
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              iconTheme: const IconThemeData(color: darkHighlight, size: 35),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Text(blobLink),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => doStuffWithImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt),
                        ),
                        Text("Take Picture"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => doStuffWithImage(ImageSource.gallery),
                          icon: Icon(Icons.image),
                        ),
                        Text("From Gallery"),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: GalleryView(widget.model.sortedImages.map((i) => GalleryImage("", i)).toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
