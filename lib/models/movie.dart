// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Movie {
  final String title;
  final String downloadlink;
  final String type;
  final String movieImgurl;
  final String rating;
  final String id;
  final String youtubetrailer;

  Movie({
    required this.title,
    required this.downloadlink,
    required this.type,
    required this.movieImgurl,
    required this.rating,
    required this.id,
    required this.youtubetrailer,
  });

  Movie copyWith({
    String? title,
    String? downloadlink,
    String? type,
    String? movieImgurl,
    String? rating,
    String? id,
    String? youtubetrailer,
  }) {
    return Movie(
      title: title ?? this.title,
      downloadlink: downloadlink ?? this.downloadlink,
      type: type ?? this.type,
      movieImgurl: movieImgurl ?? this.movieImgurl,
      rating: rating ?? this.rating,
      id: id ?? this.id,
      youtubetrailer: youtubetrailer ?? this.youtubetrailer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'downloadlink': downloadlink,
      'type': type,
      'movieImgurl': movieImgurl,
      'rating': rating,
      'id': id,
      'youtubetrailer': youtubetrailer,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    print(map);
    return Movie(
      title: map['title'] ?? '',
      downloadlink: map['downloadlink'] ?? '',
      type: map['type'] as String,
      movieImgurl: map['movieImgurl'] ??
          "https://firebasestorage.googleapis.com/v0/b/torihd-1ed20.appspot.com/o/image12024-07-25%2020%3A00%3A41.684202?alt=media&token=ac8fadb2-6632-45c5-ae77-d921ec459ca1",
      rating: map['rating'] ?? '',
      id: map['id'] ?? '',
      youtubetrailer: map['youtubetrailer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Movie(title: $title, downloadlink: $downloadlink, type: $type, movieImgurl: $movieImgurl, rating: $rating, id: $id, youtubetrailer: $youtubetrailer)';
  }

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.downloadlink == downloadlink &&
        other.type == type &&
        other.movieImgurl == movieImgurl &&
        other.rating == rating &&
        other.id == id &&
        other.youtubetrailer == youtubetrailer;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        downloadlink.hashCode ^
        type.hashCode ^
        movieImgurl.hashCode ^
        rating.hashCode ^
        id.hashCode ^
        youtubetrailer.hashCode;
  }
}
