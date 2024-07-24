import 'dart:convert';

class MovieModel {
  final String id;
  final String title;
  final String downloadlink;
  final String Youtubetrailer;
  final String movieImag;

  MovieModel({
    required this.id,
    required this.title,
    required this.downloadlink,
    required this.Youtubetrailer,
    required this.movieImag,
  });

  MovieModel copyWith({
    String? id,
    String? title,
    String? downloadlink,
    String? Youtubetrailer,
    String? movieImag,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      downloadlink: downloadlink ?? this.downloadlink,
      Youtubetrailer: Youtubetrailer ?? this.Youtubetrailer,
      movieImag: movieImag ?? this.movieImag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'downloadlink': downloadlink,
      'Youtubetrailer': Youtubetrailer,
      'movieImag': movieImag,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map, String id) {
    return MovieModel(
      id: id,
      title: map['title'] as String,
      downloadlink: map['downloadlink'] as String,
      Youtubetrailer: map['Youtubetrailer'] as String,
      movieImag: map['movieImag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source,String id) =>
      MovieModel.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, downloadlink: $downloadlink, Youtubetrailer: $Youtubetrailer, movieImag: $movieImag)';
  }

  @override
  bool operator ==(covariant MovieModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.downloadlink == downloadlink &&
        other.Youtubetrailer == Youtubetrailer &&
        other.movieImag == movieImag;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        downloadlink.hashCode ^
        Youtubetrailer.hashCode ^
        movieImag.hashCode;
  }
}
