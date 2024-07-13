// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final int? id;
  final String name;
  final double price;
  final String productImage;
  final double rating;
  final bool? sold;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.productImage,
    required this.rating,
    this.sold,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      "productImage": productImage,
      'rating': rating,
      'sold': sold,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // print(map);
    return Product(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      price: map['price'] as double,
      productImage: map["productImage"] as String,
      rating: map['rating'] as double,
      sold: map['sold'] != null ? map['sold'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
