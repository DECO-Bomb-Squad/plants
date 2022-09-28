import 'package:app/api/plant_api.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/secrets.dart';
import 'package:app/utils/colour_scheme.dart';
import 'package:app/utils/image_gallery.dart';
import 'package:app/utils/visual_pattern.dart';
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

  void addImage(ImageSource source) async {
    // get Image from imagepicker
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    // Transfer image to bytes, send to Azure
    Uint8List imgBytes = await image.readAsBytes();
    var storage = AzureStorage.parse(AZURE_BLOB_CONN_STR);
    String path = "/images/${image.name}";
    await storage.putBlob(
      path,
      bodyBytes: imgBytes,
    );
    // Get permanent access URI from Azure
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
                    imageGetter("Take Picture", Icons.camera_alt, ImageSource.camera),
                    spacer,
                    imageGetter("From Gallery", Icons.image, ImageSource.gallery),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
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

  Widget imageGetter(String subtitleText, IconData icon, ImageSource source) => Expanded(
        child: Container(
          decoration: smallPostComponent,
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: IconButton(
                    onPressed: () => addImage(source),
                    icon: Icon(icon),
                  ),
                ),
              ),
              Text(subtitleText, style: subheaderStyle),
            ],
          ),
        ),
      );

  Widget get spacer => SizedBox(width: 10);
}
