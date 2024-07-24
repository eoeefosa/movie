import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Downloads extends StatelessWidget {
  const Downloads({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
      ),
      body: const TabDownload(),
    );
  }
}

class TabDownload extends StatelessWidget {
  const TabDownload({super.key});

  Future<List<FileSystemEntity>> _getDownloads() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${directory.path}/downloads');
    if (await downloadDir.exists()) {
      return downloadDir.listSync();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDownloads(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<FileSystemEntity> downloads = snapshot.data ?? [];
            return ListView(
              children: [
                Text("Downloaded (${downloads.length})"),
                ...List.generate(
                  downloads.length,
                  (index) {
                    final file = downloads[index] as File;
                    return DownloadCard(
                      title: file.path.split('/').last,
                      size: file.lengthSync() / (1024 * 1024),
                      movieimg: file.path,
                      folder: file.parent.path,
                      duration: _getVideoDuration(
                          file), // Implement this method to get video duration
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  double _getVideoDuration(File file) {
    // Implement a method to get the video duration in seconds
    // You can use a video metadata extraction package to achieve this
    return 0; // Placeholder
  }
}

class DownloadCard extends StatelessWidget {
  const DownloadCard({
    super.key,
    required this.title,
    required this.size,
    required this.movieimg,
    required this.folder,
    required this.duration,
  });

  final String title;
  final double size;
  final String movieimg;
  final String folder;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: screensize.width * 0.3,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints.expand(
                width: 150,
                height: 60,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: const ColorFilter.srgbToLinearGamma(),
                  image: FileImage(File(movieimg)),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 4,
                    right: 0,
                    child: Text(
                      secondsToHoursMinutes(duration),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: screensize.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text("${size.toStringAsFixed(2)} MB"),
                Row(
                  children: [
                    const Icon(
                      Icons.folder,
                    ),
                    Text(folder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String secondsToHoursMinutes(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
