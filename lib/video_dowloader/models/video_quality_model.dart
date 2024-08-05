// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VideoQualityModel {
  final String? url;
  final String quality;

  VideoQualityModel({
    required this.url,
    required this.quality,
  });

  VideoQualityModel copyWith({
    String? url,
    String? quality,
  }) {
    return VideoQualityModel(
      url: url ?? this.url,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'quality': quality,
    };
  }

  factory VideoQualityModel.fromMap(Map<String, dynamic> map) {
    return VideoQualityModel(
      url: map['url'] as String,
      quality: map['quality'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoQualityModel.fromJson(String source) =>
      VideoQualityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VideoQualityModel(url: $url, quality: $quality)';

  @override
  bool operator ==(covariant VideoQualityModel other) {
    if (identical(this, other)) return true;

    return other.url == url && other.quality == quality;
  }

  @override
  int get hashCode => url.hashCode ^ quality.hashCode;
}
