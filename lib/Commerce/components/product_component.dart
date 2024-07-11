import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductComponent extends StatelessWidget {
  const ProductComponent(
      {super.key, required this.imgUrl, required this.rating});

  final String imgUrl;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints.expand(
            width: 150,
            height: 60,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: const ColorFilter.srgbToLinearGamma(),
              image: AssetImage(imgUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 4,
                left: 0,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [const Icon(Icons.star), Text(rating)],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.card_giftcard_sharp),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
