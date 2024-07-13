// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movieboxclone/Commerce/models.dart/product.dart';

class Productgroup {
  final String title;
  final Product product;

  Productgroup({required this.title, required this.product});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'product': product.toMap(),
    };
  }

  factory Productgroup.fromMap(Map<String, dynamic> map) {
    print(map);
    return Productgroup(
      title: map["title"] as String,
      product: Product.fromMap(map["product"] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Productgroup.fromJson(String source) =>
      Productgroup.fromMap(json.decode(source) as Map<String, dynamic>);
}
