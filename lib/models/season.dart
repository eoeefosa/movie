import 'package:cloud_firestore/cloud_firestore.dart';

class Season {
  int seasonNumber;
  List<Episode> episodes;

  // Constructor
  Season({
    required this.seasonNumber,
    required this.episodes,
  });

  // Named constructor to create a Season from a JSON map
  factory Season.fromJson(Map<String, dynamic> json) {
    var episodeList =
        (json['episodes'] as List).map((e) => Episode.fromJson(e)).toList();

    return Season(
      seasonNumber: json['seasonNumber'] ?? '',
      episodes: episodeList,
    );
  }

  // Method to convert a Season object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}

class Episode {
  int episodeNumber;
  String? title;
  String? description;
  String? releaseDate;
  List<DownloadLink>? downloadLinks;

  // Constructor
  Episode({
    required this.episodeNumber,
    this.title,
    this.description,
    this.releaseDate,
    required this.downloadLinks,
  });

  // Named constructor to create an Episode from a JSON map
  factory Episode.fromJson(Map<String, dynamic> json) {
    var downloadLinkList = (json['downloadLinks'] as List)
        .map((d) => DownloadLink.fromJson(d))
        .toList();

    return Episode(
      episodeNumber: int.tryParse(json['episodeNumber'].toString()) ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      downloadLinks: downloadLinkList,
    );
  }

  // Method to convert an Episode object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
      'releaseDate': releaseDate,
      'downloadLinks': downloadLinks?.map((d) => d.toJson()).toList(),
    };
  }
}

class DownloadLink {
  final String url;
  final DateTime? downloadLinkExpiration;

  // Constructor
  const DownloadLink({
    this.downloadLinkExpiration,
    required this.url,
  });

  // Named constructor to create a DownloadLink from a JSON map
  factory DownloadLink.fromJson(Map<String, dynamic> json) {
    return DownloadLink(
      url: json['url'] ?? '',
      downloadLinkExpiration: json['downloadLinkExpiration'] != null
          ? (json['downloadLinkExpiration'] as Timestamp)
              .toDate() // Convert Firestore Timestamp to DateTime
          : null,
    );
  }

  // Method to convert a DownloadLink object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'downloadLinkExpiration': downloadLinkExpiration != null
          ? Timestamp.fromDate(
              downloadLinkExpiration!) // Convert DateTime to Firestore Timestamp
          : null,
    };
  }
}
