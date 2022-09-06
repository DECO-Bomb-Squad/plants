import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GalleryImage {
  final String title;
  final String image;
  GalleryImage(this.title, this.image);
}

class GalleryView extends StatelessWidget {
  List<GalleryImage> images;
  GalleryView(this.images, {super.key});
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
                builder: (context) => PhotoView(
                  imageProvider: NetworkImage(
                    images[index].image,
                  ),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(images[index].image),
              ),
            ),
          ),
        );
      });
}
