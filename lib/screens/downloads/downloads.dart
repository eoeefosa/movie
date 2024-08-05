import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/widget/my_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  late List<VideoData> videoData;
  VideoPlayerController? _videoPlayerController;
  final List<File> _videoFiles = [];
  final List<Uint8List?> _videoThumbnails = [];

  @override
  void initState() {
    super.initState();
    // Fetch movies after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).loadFiles();
    });
  }

  // void requeststoragePermission() async {
  //   var status = await Permission.videos.status;
  //   if (status.isGranted) {
  //     print("Permision is granted");
  //   } else if (status.isDenied) {
  //     if (await Permission.videos.request().isGranted) {
  //       print("Permisson was granted");
  //     }
  //   }
  // }

  void _initializeVideoPlayer(String filePath) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  void _playPauseVideo() {
    setState(() {
      _videoPlayerController!.value.isPlaying
          ? _videoPlayerController!.pause()
          : _videoPlayerController!.play();
    });
  }

  void _stopVideo() {
    _videoPlayerController!.pause();
    _videoPlayerController!.seekTo(Duration.zero);
  }

  void _increaseVolume() {
    final currentVolume = _videoPlayerController!.value.volume;
    _videoPlayerController!.setVolume((currentVolume + 0.1).clamp(0.0, 1.0));
  }

  void _decreaseVolume() {
    final currentVolume = _videoPlayerController!.value.volume;
    _videoPlayerController!.setVolume((currentVolume - 0.1).clamp(0.0, 1.0));
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
      ),
      body: Consumer<MovieProvider>(builder: (context, movieProvider, child) {
        if (movieProvider.loadingdownloads) {
          return const Center(child: CircularProgressIndicator());
        } else if (movieProvider.downloads.isEmpty) {
          return const Center(
            child: Text("No video files found in Downloads folder"),
          );
        } else {
          final downloads = movieProvider.downloads;
          final data = movieProvider.videoData;

          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: downloads.length,
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemBuilder: (context, index) {
                  int reverseIndex = downloads.length - 1 - index;
                  print(data.length);

                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyThumbnail(
                        path: downloads[reverseIndex]!.path,
                        data: data[0],
                        onVideoDeleted: () {},
                      ),
                    ),
                  );
                },
              ));
        }
      }),
    );
  }
}
