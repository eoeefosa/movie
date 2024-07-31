import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torihd/screens/downloads/tabs/tab_download.dart';
import 'package:video_player/video_player.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  VideoPlayerController? _videoPlayerController;
  List<File> _videoFile = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermissionAnLoadFiles();
  }

  Future<void> _requestPermissionAnLoadFiles() async {
    if (await Permission.storage.request().isGranted) {
      _loadVideoFiles();
    }
  }

  Future<void> _loadVideoFiles() async {
    Directory downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    final videoFiles = downloadsDir
        .listSync()
        .where((file) =>
            file.path.endsWith('.mp4') ||
            file.path.endsWith('.mov') ||
            file.path.endsWith('.mkv') ||
            file.path.endsWith('.avi'))
        .toList();

    setState(() {
      _videoFile = videoFiles.map((file) => File(file.path)).toList();
    });
  }

  void _initializeVideoPlayer(String filePath) {
    _videoPlayerController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
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
      body: Center(
        child: _videoFile.isEmpty
            ? const Text('No video files found in Downloads folder.')
            : ListView.builder(
                itemCount: _videoFile.length,
                itemBuilder: (context, index) {
                  final file = _videoFile[index];
                  return ListTile(
                    title: Text(file.path.split('/').last),
                    onTap: () {
                      _initializeVideoPlayer(file.path);
                    },
                  );
                },
              ),
      ),
      floatingActionButton: _videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _videoPlayerController!.value.isPlaying
                      ? _videoPlayerController!.pause()
                      : _videoPlayerController!.play();
                });
              },
              child: Icon(
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,

      // body: const TabDownload(),
    );
  }
}
