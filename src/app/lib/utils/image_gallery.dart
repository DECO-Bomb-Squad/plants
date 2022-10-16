import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GalleryImage {
  final String title;
  final String image;
  GalleryImage(this.title, this.image);
}

class GalleryView extends StatelessWidget {
  List<GalleryImage> images;
  GalleryView(this.images, {super.key, this.deleteCallback});
  final void Function(String)? deleteCallback;

  void deleteImage(int index, BuildContext context) {
    Navigator.of(context).pop(); // pop so that we're not viewing the photo anymore
    if (deleteCallback != null) {
      deleteCallback!(images[index].image);
    }
    images.removeAt(index);
  }

  @override
  Widget build(BuildContext context) => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Stack(
                    children: [
                      PhotoView(
                        imageProvider: CachedNetworkImageProvider(
                          images[index].image,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => deleteImage(index, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(images[index].image),
              ),
            ),
          ),
        );
      });
}
