import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatelessWidget {
  const CategoryComponent(
      {super.key,
      required this.imgUrl,
      required this.cartName,
      required this.isonline});
  final String imgUrl;
  final String cartName;
// TODO: Remove only for test
  final bool isonline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isonline
            ? CachedNetworkImage(
                imageUrl: imgUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: AssetImage(imgUrl),
                ),
              ),
        Text(cartName),
      ],
    );
  }
}
