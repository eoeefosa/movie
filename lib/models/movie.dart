// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:torihd/models/season.dart';

class Movie {
  final String movieImgurl;
  final String type;
  final String title;
  final String rating;
  final String detail;
  final String description;
  final String? downloadlink;
  final String? id;
  final String youtubetrailer;
  final String? source;
  final String? releasedate;
  final String? country;
  final List<String>? cast;
  final List<String>? language;
  final List<String>? tags;
  final String? genre;
  final DateTime? downloadLinkExpiration;
  final List<Season>? seasons;

  Movie({
    required this.movieImgurl,
    required this.type,
    required this.title,
    required this.rating,
    required this.detail,
    required this.description,
    this.downloadlink,
    required this.id,
    required this.youtubetrailer,
    this.source,
    this.releasedate,
    this.country,
    this.cast,
    this.language,
    this.tags,
    this.genre,
    this.downloadLinkExpiration,
    this.seasons,
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
    List<Season>? seasons, // Add seasons to copyWith
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
      seasons: seasons ?? this.seasons, // Add seasons to copyWith
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
      'downloadLinkExpiration': downloadLinkExpiration != null
          ? Timestamp.fromDate(downloadLinkExpiration!)
          : null,
      'seasons': seasons?.map((Season x) => x.toJson()).toList(), // Convert seasons to Map
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieImgurl: map['movieImgUrl'] ?? map['movieImgurl'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      rating: map['rating'] ?? '',
      detail: map['detail'] ?? '',
      description: map['description'] ?? '',
      downloadlink: map['downloadlink'] ?? '',
      id: map['id'] ?? '',
      youtubetrailer: map['youtubetrailer'] ?? '',
      source: map['source'] ?? '',
      releasedate: map['releasedate'] != null ? map['releasedate'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      cast: map['cast'] != null ? List<String>.from(map['cast'] as List) : null,
      language: map['language'] != null ? List<String>.from(map['language'] as List) : null,
      tags: map['tags'] != null ? List<String>.from(map['tags'] as List) : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
      downloadLinkExpiration: map['downloadLinkExpiration'] != null
          ? (map['downloadLinkExpiration'] as Timestamp).toDate()
          : null,
      seasons: map['seasons'] != null
          ? List<Season>.from(
              (map['seasons'] as List<dynamic>)
                  .map<Season>((dynamic item) => Season.fromJson(item)),
            )
          : null, // Deserialize seasons
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Movie(movieImgurl: $movieImgurl, type: $type, title: $title, rating: $rating, detail: $detail, description: $description, downloadlink: $downloadlink, id: $id, youtubetrailer: $youtubetrailer, source: $source, releasedate: $releasedate, country: $country, cast: $cast, language: $language, tags: $tags, genre: $genre, seasons: $seasons)';
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
        other.genre == genre &&
        listEquals(other.seasons, seasons); // Compare seasons
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
        genre.hashCode ^
        seasons.hashCode; // Include seasons in hashcode
  }
}
