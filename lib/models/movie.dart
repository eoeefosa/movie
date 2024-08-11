// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Movie {
  final String movieImgurl;
  final String type;
  final String title;
  final String rating;
  final String detail;
  final String description;
  final String downloadlink;
  final String id;
  final String youtubetrailer;
  final String source;

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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movieImgUrl': movieImgurl,
      'type': type,
      'title': title,
      'rating': rating,
      'detail': detail,
      'description': description,
      'downloadlink': downloadlink,
      'youtubetrailer': youtubetrailer,
      'source': source,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieImgurl: map['movieImgUrl'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      rating: map['rating'] ?? '',
      detail: map['detail'] ?? '',
      description: map['description'] ?? '',
      downloadlink: map['downloadlink'] ?? '',
      id: map['id'] ?? '',
      youtubetrailer: map['youtubetrailer'] ?? '',
      source: map['source'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Movie(movieImgurl: $movieImgurl, type: $type, title: $title, rating: $rating, detail: $detail, description: $description, downloadlink: $downloadlink, id: $id, youtubetrailer: $youtubetrailer, source: $source)';
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
        other.source == source;
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
        source.hashCode;
  }
}
