import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StatusVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final String videoSrc;
  final double? aspectRatio;
  const StatusVideo(
      {super.key,
      required this.videoPlayerController,
      required this.looping,
      required this.videoSrc,
      this.aspectRatio});

  @override
  State<StatusVideo> createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      looping: widget.looping,
      autoPlay: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AspectRatio(
        aspectRatio: 1,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
