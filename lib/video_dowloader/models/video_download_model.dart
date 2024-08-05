// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:torihd/video_dowloader/models/video_quality_model.dart';

class VideoDownloadModel {
  final String? title;
  final String? source;
  final String? thumbnail;
  final List<VideoQualityModel> videos;

  VideoDownloadModel({
    this.title,
    this.source,
    this.thumbnail,
    required this.videos,
  });

  VideoDownloadModel copyWith({
    String? title,
    String? source,
    String? thumbnail,
    List<VideoQualityModel>? videos,
  }) {
    return VideoDownloadModel(
      title: title ?? this.title,
      source: source ?? this.source,
      thumbnail: thumbnail ?? this.thumbnail,
      videos: videos ?? this.videos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'source': source,
      'thumbnail': thumbnail,
      'videos': videos.map((x) => x.toMap()).toList(),
    };
  }

  factory VideoDownloadModel.fromMap(Map<String, dynamic> map) {
    return VideoDownloadModel(
      title: map['title'] != null ? map['title'] as String : null,
      source: map['source'] != null ? map['source'] as String : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      videos: List<VideoQualityModel>.from(
        (map['videos'] as List<int>).map<VideoQualityModel>(
          (x) => VideoQualityModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoDownloadModel.fromJson(String source) =>
      VideoDownloadModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoDownloadModel(title: $title, source: $source, thumbnail: $thumbnail, videos: $videos)';
  }

  @override
  bool operator ==(covariant VideoDownloadModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.source == source &&
        other.thumbnail == thumbnail &&
        listEquals(other.videos, videos);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        source.hashCode ^
        thumbnail.hashCode ^
        videos.hashCode;
  }
}
