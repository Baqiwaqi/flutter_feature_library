import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.person),
          imageUrl: "data.url" ?? "",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
