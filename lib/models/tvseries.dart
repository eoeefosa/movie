import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torihd/models/season.dart';

class TVSeries {
  String id;
  String title;
  String imageUrl;
  String rating;
  String description;
  String youtubeLink;
  String source;
  String country;
  String cast;
  String releaseDate;
  String language;
  String tags;
  List<Season> seasons;

  // Constructor
  TVSeries({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.youtubeLink,
    required this.source,
    required this.country,
    required this.cast,
    required this.releaseDate,
    required this.language,
    required this.tags,
    required this.seasons,
  });

  // Named constructor to create a TVSeries from a JSON map
  factory TVSeries.fromJson(Map<String, dynamic> json) {
    var seasonList =
        (json['seasons'] as List).map((s) => Season.fromJson(s)).toList();

    return TVSeries(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating'] ?? '',
      description: json['description'] ?? '',
      youtubeLink: json['youtubeLink'] ?? '',
      source: json['source'] ?? '',
      country: json['country'] ?? '',
      cast: json['cast'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      language: json['language'] ?? '',
      tags: json['tags'] ?? '',
      seasons: seasonList,
    );
  }

  // Method to convert a TVSeries object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
      'youtubeLink': youtubeLink,
      'source': source,
      'country': country,
      'cast': cast,
      'releaseDate': releaseDate,
      'language': language,
      'tags': tags,
      'seasons': seasons.map((s) => s.toJson()).toList(),
    };
  }
}
