import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:torihd/components/download_taskinfo.dart';
import 'package:torihd/models/appState/downloadtask.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _getDownloads(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<FileSystemEntity> downloads = snapshot.data ?? [];
            return Consumer<DownloadProvider>(
                builder: (context, movieProvider, child) {
              if (movieProvider.filesdownloading) {
                return const Center(child: CircularProgressIndicator());
              } else if (movieProvider.downloads.isEmpty) {
                return const Center(
                  child: Text("No downloads available"),
                );
              } else {
                return Column(
                  children: [
                    Text("Downloading (${movieProvider.downloads.length})"),
                    SizedBox(
                      height: size.height * .3,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final taskInfo = movieProvider.downloads[index];
                          return DownloadTaskCard(taskInfo: taskInfo);
                        },
                        itemCount: movieProvider.downloads.length,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                    Text("Downloaded (${downloads.length})"),
                    SizedBox(
                      height: size.height * .4,
                      child:
                          // ListView(
                          //   children: [
                          //     ...List.generate(
                          //       downloads.length,
                          //       (index) {
                          //         final file = downloads[index] as File;
                          //         final downloadTask = downloadProvider.downloads
                          //             .firstWhere(
                          //                 (task) =>
                          //                     task.filename ==
                          //                     file.path.split('/').last,
                          //                 orElse: () => DownloadTaskInfo(
                          //                     id: '',
                          //                     url: '',
                          //                     filename: file.path.split('/').last));
                          //         return DownloadCard(
                          //           title: file.path.split('/').last,
                          //           size: file.lengthSync() / (1024 * 1024),
                          //           movieimg: file.path,
                          //           folder: file.parent.path,
                          //           duration: _getVideoDuration(
                          //               file), // Implement this method to get video duration
                          //           downloadTask: downloadTask,
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                          Consumer<DownloadProvider>(
                        builder: (context, downloadProvider, child) {
                          final downloads = downloadProvider.downloads;

                          return ListView.builder(
                            itemCount: downloads.length,
                            itemBuilder: (context, index) {
                              final download = downloads[index];
                              return ListTile(
                                title: Text(download.filename),
                                subtitle:
                                    Text('Progress: ${download.progress}%'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (download.status ==
                                        DownloadTaskStatus.running)
                                      IconButton(
                                        icon: const Icon(Icons.pause),
                                        onPressed: () {
                                          downloadProvider
                                              .pauseDownload(download.id);
                                        },
                                      ),
                                    if (download.status ==
                                        DownloadTaskStatus.paused)
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () {
                                          downloadProvider
                                              .resumeDownload(download.id);
                                        },
                                      ),
                                    if (download.status ==
                                        DownloadTaskStatus.failed)
                                      IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: () {
                                          downloadProvider.addDownload(
                                              download.url, download.filename);
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        downloadProvider
                                            .removeDownload(download.id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            });
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
    required this.downloadTask,
  });

  final String title;
  final double size;
  final String movieimg;
  final String folder;
  final double duration;
  final DownloadTaskInfo downloadTask;

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);

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
                LinearProgressIndicator(
                  value: downloadTask.progress / 100,
                ),
                Row(
                  children: [
                    if (downloadTask.status == DownloadTaskStatus.running)
                      IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: () =>
                            downloadProvider.pauseDownload(downloadTask.id),
                      ),
                    if (downloadTask.status == DownloadTaskStatus.paused)
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () =>
                            downloadProvider.resumeDownload(downloadTask.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        downloadProvider.removeDownload(downloadTask.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Download for ${downloadTask.filename} removed.')),
                        );
                      },
                    ),
                  ],
                ),
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
