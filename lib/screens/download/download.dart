import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader extends StatefulWidget {
  const FileDownloader({super.key});

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  final imgUrl = "https://images6.alphacoders.com/683/thumb-1920-683023.jpg";
  bool downloading = false;
  double progress = 0.0;
  List<String> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadFile(String url, String fileName) async {
    Dio dio = Dio();
    PermissionStatus result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        Directory? downloadDirectory = await getExternalStorageDirectory();
        if (downloadDirectory != null) {
          Directory toriDirectory =
              Directory('${downloadDirectory.path}/Tohri');
          if (!await toriDirectory.exists()) {
            await toriDirectory.create(recursive: true);
          }
          dirloc = toriDirectory.path;
        }
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      String filePath = "$dirloc/$fileName";

      try {
        setState(() {
          downloading = true;
        });

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                progress = received / total;
              });
            }
          },
          options: Options(
            headers: {HttpHeaders.acceptEncodingHeader: '*'},
          ),
        );

        setState(() {
          downloading = false;
          downloadedFiles.add(filePath);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: $filePath')),
        );
      } catch (e) {
        setState(() {
          downloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                downloadFile(
                  "https://images6.alphacoders.com/683/thumb-1920-683023.jpg",
                  "froseimage.jpg",
                );
              },
              child: const Text("Download"),
            ),
            if (downloading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const Text("Downloading..."),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                    ),
                    const SizedBox(height: 10),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Downloaded Files:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: downloadedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(downloadedFiles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
