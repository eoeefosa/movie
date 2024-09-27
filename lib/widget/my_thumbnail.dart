import 'dart:io';

import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

import '../videoplayerscreen/videoplayerscreen.dart';

class MyThumbnail extends StatefulWidget {
  final String path;
  final VideoData data;
  final VoidCallback onVideoDeleted;

  const MyThumbnail({
    super.key,
    required this.path,
    required this.data,
    required this.onVideoDeleted,
  });

  @override
  State<MyThumbnail> createState() => _MyThumbnailState();
}

class _MyThumbnailState extends State<MyThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    var file = File(widget.path);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        // Seek to 10% of the video duration or 5 minutes, whichever is smaller
        final duration = _controller!.value.duration;
        final targetPosition = duration.inSeconds * 0.1 < 300
            ? Duration(seconds: (duration.inSeconds * 0.1).toInt())
            : const Duration(minutes: 5);

        _controller!.seekTo(targetPosition).then((_) {
          setState(() {});
        });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(path: widget.path),
          ),
        );
      },
      child: Row(
        children: [
          SizedBox(
            width: 130.w,
            height: 100.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    _controller == null || !_controller!.value.isInitialized
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.grey,
                              width: double.infinity,
                            ),
                          )
                        : VideoPlayer(_controller!),
                    if (_controller != null && _controller!.value.isInitialized)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          color: Colors.black54,
                          child: Text(
                            _formatDuration(_controller!.value.duration),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  widget.data.title ?? 'Unknown Title',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  FileSize.getSize(widget.data.filesize as int),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const RotatedBox(quarterTurns: 1, child: Icon(Icons.more_horiz)),
              SizedBox(
                height: 10.h,
              )
            ],
          )
        ],
      ),
    );
  }
}
