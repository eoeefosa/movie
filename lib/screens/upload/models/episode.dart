import 'package:flutter/material.dart';

class EpisodeController {
  final int episodeNumber;
  final TextEditingController episodeController;
  final TextEditingController titleController; // Added a description controller
  final TextEditingController
      descriptionController; // Added a description controller
  final TextEditingController
      releaseDateController; // Added a release date controller
  final TextEditingController
      downloadLinkController; // Added a download link controller

  EpisodeController({
    required this.episodeNumber,
    TextEditingController? episodeController,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    TextEditingController? releaseDateController,
    required TextEditingController? downloadLinkController,
  })  : episodeController = episodeController ?? TextEditingController(),
        titleController = titleController ?? TextEditingController(),
        descriptionController =
            descriptionController ?? TextEditingController(),
        releaseDateController =
            releaseDateController ?? TextEditingController(),
        downloadLinkController =
            downloadLinkController ?? TextEditingController();

  // Factory constructor for creating an EpisodeController from a Map
  factory EpisodeController.fromMap(Map<String, dynamic> data) {
    return EpisodeController(
      episodeNumber: data['episodeNumber'] as int,
      episodeController:
          TextEditingController(text: data['episode'] as String? ?? ''),
      titleController:
          TextEditingController(text: data['title'] as String? ?? ''),
      descriptionController:
          TextEditingController(text: data['description'] as String? ?? ''),
      releaseDateController:
          TextEditingController(text: data['releaseDate'] as String? ?? ''),
      downloadLinkController:
          TextEditingController(text: data['downloadLink'] as String? ?? ''),
    );
  }

  // Method to convert the EpisodeController back to a Map
  Map<String, dynamic> toMap() {
    return {
      'episodeNumber': episodeNumber,
      'episode': episodeController.text,
      'title': titleController.text,
      'description': descriptionController.text,
      'releaseDate': releaseDateController.text,
      'downloadLink': downloadLinkController.text,
    };
  }

  // Dispose method to clean up the controllers when no longer needed
  void dispose() {
    episodeController.dispose();
    descriptionController.dispose();
    titleController.dispose();
    releaseDateController.dispose();
    downloadLinkController.dispose();
  }
}
