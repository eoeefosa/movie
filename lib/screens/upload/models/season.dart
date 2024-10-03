import 'package:flutter/material.dart';
import 'package:torihd/screens/upload/models/episode.dart';

class SeasonController {
  final int seasonNumber;
  final List<EpisodeController> episodes;
  final TextEditingController seasonController;


  SeasonController({
    required this.seasonNumber,
    required this.episodes,
  TextEditingController? seasonController
  }):
  seasonController = seasonController ?? TextEditingController(text: "1");

  // Similar factory for parsing JSON-like data
  factory SeasonController.fromMap(Map<String, dynamic> data) {
    return SeasonController(
      seasonNumber: data['seasonNumber'] as int,
      episodes: (data['episodes'] as List<dynamic>)
          .map((e) => EpisodeController.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
