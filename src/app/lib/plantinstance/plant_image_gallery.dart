import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/image_gallery.dart';
import 'package:azblob/azblob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PlantGalleryScreen extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;

  const PlantGalleryScreen(this.plantID, this.model, {super.key});

  @override
  State<PlantGalleryScreen> createState() => _PlantGalleryScreenState();
}

class _PlantGalleryScreenState extends State<PlantGalleryScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(rebuild);
  }

  void rebuild() {
    setState(() {});
  }

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
    String blobLink = (await storage.getBlobLink(path)).toString();
    widget.model.addNewImage(blobLink, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (() => Navigator.of(context).pop())),
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
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => doStuffWithImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                        ),
                        const Text("Take Picture"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => doStuffWithImage(ImageSource.gallery),
                          icon: const Icon(Icons.image),
                        ),
                        const Text("From Gallery"),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: GalleryView(
                  widget.model.sortedImages.map((i) => GalleryImage("", i)).toList(),
                  deleteCallback: widget.model.removeImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
