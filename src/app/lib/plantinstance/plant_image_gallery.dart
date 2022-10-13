import 'package:app/api/plant_api.dart';
import 'package:app/base/header_sliver.dart';
import 'package:app/plantinstance/plant_info_model.dart';
import 'package:app/secrets.dart';
import 'package:app/utils/image_gallery.dart';
import 'package:app/utils/visual_pattern.dart';
import 'package:azblob/azblob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class PlantGalleryScreen extends StatefulWidget {
  final int plantID;
  final PlantInfoModel model;

  const PlantGalleryScreen(this.plantID, this.model, {super.key});

  @override
  State<PlantGalleryScreen> createState() => _PlantGalleryScreenState();
}

class _PlantGalleryScreenState extends State<PlantGalleryScreen> {
  late bool belongsToMe;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(rebuild);
    int myId = GetIt.I<PlantAPI>().user!.id;
    int plantOwnerId = widget.model.ownerId;
    belongsToMe = (myId == plantOwnerId);
  }

  @override
  void dispose() {
    super.dispose();
    widget.model.removeListener(rebuild);
  }

  void rebuild() {
    setState(() {});
  }

  // Retrieve image bytes from a picture the user uploads or takes
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
    String blobLink = (await storage.getBlobLink(path, expiry: DateTime(2022, 12, 30))).toString();
    widget.model.addNewImage(blobLink, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: StandardHeaderBuilder,
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              if (belongsToMe)
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
          padding: const EdgeInsets.all(5),
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

  Widget get spacer => const SizedBox(width: 10);
}
