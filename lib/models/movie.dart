// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Movie {
  final String movieImgurl;
  final String type;
  final String title;
  final String rating;
  final String detail;
  final String description;
  final String downloadlink;
  final String? id;
  final String youtubetrailer;
  final String? source;
  final String? releasedate;
  final String? country;
  final List<String>? cast;
  final List<String>? language;
  final List<String>? tags;
  final String? genre;

  Movie({
    required this.movieImgurl,
    required this.type,
    required this.title,
    required this.rating,
    required this.detail,
    required this.description,
    required this.downloadlink,
    required this.id,
    required this.youtubetrailer,
    required this.source,
    this.releasedate,
    this.country,
    this.cast,
    this.language,
    this.tags,
    this.genre,
  });

  Movie copyWith({
    String? movieImgurl,
    String? type,
    String? title,
    String? rating,
    String? detail,
    String? description,
    String? downloadlink,
    String? id,
    String? youtubetrailer,
    String? source,
    String? releasedate,
    String? country,
    List<String>? cast,
    List<String>? language,
    List<String>? tags,
    String? genre,
  }) {
    return Movie(
      movieImgurl: movieImgurl ?? this.movieImgurl,
      type: type ?? this.type,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      detail: detail ?? this.detail,
      description: description ?? this.description,
      downloadlink: downloadlink ?? this.downloadlink,
      id: id ?? this.id,
      youtubetrailer: youtubetrailer ?? this.youtubetrailer,
      source: source ?? this.source,
      releasedate: releasedate ?? this.releasedate,
      country: country ?? this.country,
      cast: cast ?? this.cast,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      genre: genre ?? this.genre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movieImgurl': movieImgurl,
      'type': type,
      'title': title,
      'rating': rating,
      'detail': detail,
      'description': description,
      'downloadlink': downloadlink,
      'id': id,
      'youtubetrailer': youtubetrailer,
      'source': source,
      'releasedate': releasedate,
      'country': country,
      'cast': cast,
      'language': language,
      'tags': tags,
      'genre': genre,
    };
  }

  factory Movie.fromMap(
    Map<String, dynamic> map,
  ) {
    print(map['id']);
    return Movie(
      movieImgurl: map['movieImgUrl'] ?? '', // Provide default value if null
      type: map['type'] ?? '', // Provide default value if null
      title: map['title'] ?? '', // Provide default value if null
      rating: map['rating'] ?? '', // Provide default value if null
      detail: map['detail'] ?? '', // Provide default value if null
      description: map['description'] ?? '', // Provide default value if null
      downloadlink: map['downloadlink'] ?? '', // Provide default value if null
      id: map['id'] ?? '',
      youtubetrailer:
          map['youtubetrailer'] ?? '', // Provide default value if null
      source: map['source'] ?? '', // Safe null handling for optional fields
      releasedate:
          map['releasedate'] != null ? map['releasedate'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      cast: map['cast'] != null
          ? List<String>.from(map['cast'] as List) // Safe casting
          : null,
      language: map['language'] != null
          ? List<String>.from(map['language'] as List) // Safe casting
          : null,
      tags: map['tags'] != null
          ? List<String>.from(map['tags'] as List) // Safe casting
          : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
    );
  }
  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Movie(movieImgurl: $movieImgurl, type: $type, title: $title, rating: $rating, detail: $detail, description: $description, downloadlink: $downloadlink, id: $id, youtubetrailer: $youtubetrailer, source: $source, releasedate: $releasedate, country: $country, cast: $cast, language: $language, tags: $tags, genre: $genre)';
  }

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.movieImgurl == movieImgurl &&
        other.type == type &&
        other.title == title &&
        other.rating == rating &&
        other.detail == detail &&
        other.description == description &&
        other.downloadlink == downloadlink &&
        other.id == id &&
        other.youtubetrailer == youtubetrailer &&
        other.source == source &&
        other.releasedate == releasedate &&
        other.country == country &&
        listEquals(other.cast, cast) &&
        listEquals(other.language, language) &&
        listEquals(other.tags, tags) &&
        other.genre == genre;
  }

  @override
  int get hashCode {
    return movieImgurl.hashCode ^
        type.hashCode ^
        title.hashCode ^
        rating.hashCode ^
        detail.hashCode ^
        description.hashCode ^
        downloadlink.hashCode ^
        id.hashCode ^
        youtubetrailer.hashCode ^
        source.hashCode ^
        releasedate.hashCode ^
        country.hashCode ^
        cast.hashCode ^
        language.hashCode ^
        tags.hashCode ^
        genre.hashCode;
  }
}
