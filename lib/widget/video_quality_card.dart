import 'package:flutter/material.dart';
import 'package:torihd/video_dowloader/models/video_quality_model.dart';
import 'package:torihd/video_dowloader/repository/video_downlad_repository.dart';

class VideoQualityCard extends StatefulWidget {
  final VideoQualityModel model;
  final VoidCallback onTap;
  final VideoType type;
  final bool isSelected;

  const VideoQualityCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.type,
    required this.isSelected,
  });

  @override
  State<VideoQualityCard> createState() => _VideoQualityCardState();
}

class _VideoQualityCardState extends State<VideoQualityCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
