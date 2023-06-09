import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostsWidget extends StatelessWidget {
  final List<String> thumbnails;

  const PostsWidget({required this.thumbnails});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: thumbnails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        String thumbnail = thumbnails[index];
        return CachedNetworkImage(
          imageUrl: thumbnail,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
