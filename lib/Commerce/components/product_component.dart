import 'package:flutter/material.dart';

class ProductComponent extends StatelessWidget {
  const ProductComponent({
    super.key,
    required this.imgUrl,
    required this.rating,
    required this.price,
    required this.productname,
  });

  final String imgUrl;
  final String rating;
  // final String productImg;
  final String productname;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints.expand(
            width: 150,
            height: 150,
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
                bottom: 1,
                left: 0,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [const Icon(Icons.star), Text(rating)],
                  ),
                ),
              ),
              Positioned(
                top: 1,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_checkout_outlined),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        Text(productname),
        Text("₦$price"),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Buy Now"),
        )
      ],
    );
  }
}
