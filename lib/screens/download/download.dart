import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:file_utils/file_utils.dart';

class FileDownloader extends StatefulWidget {
  const FileDownloader({super.key});

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  final imgUrl = "https://images6.alphacoders.com/683/thumb-1920-683023.jpg";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  // Permission permission1= Permission.storage.;

  var _onPressed;
  static final Random random = Random();

  late Directory externalDir;

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadFile(String url, String fileName) async {
    print("Download started");
    Dio dio = Dio();
    bool permissionGranted = await Permission.videos.isGranted;
    if (permissionGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        Directory? downloadDirectory = await getExternalStorageDirectory();
        if (downloadDirectory != null) {
          // Create the "Tori" folder
          Directory toriDirectory =
              Directory('${downloadDirectory.path}/Tohri');
          if (!await toriDirectory.exists()) {
            await toriDirectory.create(recursive: true);
          }
          dirloc = toriDirectory.path;
        }
        // dirloc=(await getDownloadsDirectory())!.path;

        // dirloc="/sdCard/Download";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
      String filePath = "$dirloc/$fileName";

      try {
        await dio.download(url,
            options: Options(
              headers: {HttpHeaders.acceptEncodingHeader: '*'}, // Disable gzip
            ), onReceiveProgress: (received, total) {
          if (total <= 0) return;
          print('percentage: ${(received / total * 100).toStringAsFixed(0)}%');
        }, filePath);
        print("Download completed: $filePath");
      } catch (e) {
        print("Download failed:$e");
      }
    } else {
      print("Storage permision not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          downloadFile(
              "https://images6.alphacoders.com/683/thumb-1920-683023.jpg",
              "froseimage.jpg");
        },
        child: const Text("Download"),
      ),
    );
  }
}
