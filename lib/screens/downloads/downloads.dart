import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/widget/my_thumbnail.dart';


class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  late List<VideoData> videoData;
  int progress = 0;
  ReceivePort receivePort = ReceivePort();

  static downloadcallback(String id, int status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("dowloadingvideo")!;
    sendPort.send(progress);
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "dowloadingvideo");

    receivePort.listen((message) {
      setState(() {
        progress = message;
        print(progress);
      });
    });
    super.initState();

    FlutterDownloader.registerCallback(downloadcallback);
    // Fetch movies after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MovieProvider>(context, listen: false);
    });
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
