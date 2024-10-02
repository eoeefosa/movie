import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the Shimmer package
import 'package:torihd/provider/downloadprovider.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/widget/my_thumbnail.dart';

// import '../../provider/downloadprovider_a.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  late List<VideoData> videoData;
  int progress = 0;
  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloadingvideo");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(
      builder: (context, downloadProvider, child) {
        int downloadingCount = downloadProvider.downloadTasks.length;

        return DefaultTabController(
          length: downloadingCount > 0
              ? 2
              : 1, // Show 2 tabs only if there are downloading files
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Downloads"),
              bottom: downloadingCount > 0
                  ? TabBar(
                      tabs: [
                        const Tab(text: "Downloaded Files"),
                        Tab(
                          text:
                              "Downloading Files ($downloadingCount)", // Show count of downloading files
                        ),
                      ],
                    )
                  : null, // Show tab bar only if there are downloading files
            ),
            body: downloadingCount > 0
                ? TabBarView(
                    children: [
                      _buildDownloadedFilesTab(context), // Downloaded Files Tab
                      _buildDownloadingFilesTab(
                          context), // Downloading Files Tab
                    ],
                  )
                : _buildDownloadedFilesTab(
                    context), // Show only Downloaded Files Tab if no downloads in progress
          ),
        );
      },
    );
  }

  // Widget for "Downloaded Files" tab
  Widget _buildDownloadedFilesTab(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.loadingdownloads) {
          return _buildShimmerList(); // Use shimmer list when loading
        } else if (movieProvider.downloads.isEmpty) {
          return const Center(
            child: Text("No video files found in Downloads folder"),
          );
        } else {
          final downloads = movieProvider.downloads;
          final data = movieProvider.videoData;

          return ListView.builder(
            itemCount: downloads.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) {
              int reverseIndex = downloads.length - 1 - index;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyThumbnail(
                  path: downloads[reverseIndex]!.path,
                  data: data[0],
                  onVideoDeleted: () {},
                ),
              );
            },
          );
        }
      },
    );
  }

  // Widget for "Downloading Files" tab
  Widget _buildDownloadingFilesTab(BuildContext context) {
    return Consumer<DownloadProvider>(
      builder: (context, downloadProvider, child) {
        if (downloadProvider.downloadTasks.isEmpty) {
          return const Center(
            child: Text("No downloads in progress"),
          );
        } else {
          return ListView.builder(
            itemCount: downloadProvider.downloadTasks.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) {
              final task =
                  downloadProvider.downloadTasks.values.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      task.hasError ? Icons.error : Icons.download,
                      color: task.hasError ? Colors.red : Colors.blue,
                    ),
                    title: Text(task.fileName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: task.progress / 100,
                          color: task.hasError ? Colors.red : Colors.green,
                        ),
                        const SizedBox(height: 8),
                        Text('${task.progress.toStringAsFixed(2)}% completed'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!task.isCompleted) ...[
                          IconButton(
                            icon: Icon(
                              task.isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              task.isPaused
                                  ? downloadProvider.resumeDownload(task.url)
                                  : downloadProvider.pauseDownload(task.url);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              downloadProvider.cancelDownload(task.url);
                            },
                          ),
                        ],
                        if (task.isCompleted) ...[
                          const Icon(Icons.check, color: Colors.green),
                        ],
                        if (task.hasError) ...[
                          IconButton(
                            icon:
                                const Icon(Icons.refresh, color: Colors.orange),
                            onPressed: () {
                              downloadProvider.startDownload(
                                  task.url, task.savePath);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6, // Number of shimmer items
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 150.h,
                        height: 20.w,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
