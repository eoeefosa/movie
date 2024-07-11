// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Categories {
  final int id;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String name;
  @JsonKey(name: 'category_image')
  final String cartegoryImg;
  final String description;

  Categories({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.name,
    required this.cartegoryImg,
    required this.description,
  });

  Categories copyWith({
    int? id,
    String? updatedAt,
    String? createdAt,
    String? name,
    String? cartegoryImg,
    String? description,
  }) {
    return Categories(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      cartegoryImg: cartegoryImg ?? this.cartegoryImg,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'name': name,
      'category_image': cartegoryImg,
      'description': description,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] as int,
      updatedAt: map['updated_at'] as String,
      createdAt: map['created_at'] as String,
      name: map['name'] as String,
      cartegoryImg: map['category_image'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) => Categories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Categories(id: $id, updatedAt: $updatedAt, createdAt: $createdAt, name: $name, cartegoryImg: $cartegoryImg, description: $description)';
  }

  @override
  bool operator ==(covariant Categories other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.updatedAt == updatedAt &&
      other.createdAt == createdAt &&
      other.name == name &&
      other.cartegoryImg == cartegoryImg &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode ^
      name.hashCode ^
      cartegoryImg.hashCode ^
      description.hashCode;
  }
}
