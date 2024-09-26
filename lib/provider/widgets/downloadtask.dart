import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';

class DownloadTask {
  final String url;
  final String savePath;
  final String fileName;
  final Dio dio;

  late CancelToken cancelToken;
  late int received;
  late int total;
  late double progress;

  List<QualityOption> qualityOptions; // Add quality options

  final Function(int received, int total) onReceiveProgress;
  // final Function(double progress) alprogress;
  final VoidCallback onComplete;
  final Function(Object error) onError;

  bool isPaused = false;
  bool isCompleted = false;
  bool hasError = false;

  DownloadTask({
    // required this.alprogress,
    required this.fileName,
    required this.url,
    required this.savePath,
    required this.dio,
    required this.onReceiveProgress,
    required this.onComplete,
    required this.onError,
    required this.qualityOptions, // Initialize quality options
  }) {
    cancelToken = CancelToken();
    received = 0;
    total = 0;
    progress = 0.0;
  }

// Start the download
  void start() async {
    print("Start download clicked");
    try {
      // Get the directory where the downloaded file will be stored
      Directory directory = Directory('/storage/emulated/0/Download/Tori');

      Response response = await dio.get(
        url,
        cancelToken: cancelToken,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print("downloading");
          print(receivedBytes);
          print(totalBytes);
          received = receivedBytes;
          total = totalBytes;
          onReceiveProgress(receivedBytes, totalBytes);
          // onReceiveProgress(receivedBytes, totalBytes);
          if (receivedBytes == totalBytes) {
            isCompleted = true;
            onComplete();
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          //receiveTimeout: 0,
        ),
      );
      // Construct the complete file path
      String filePath = '${directory.path}/$fileName';

      // Write the downloaded file to disk
      File file = File(filePath);
      await file.writeAsBytes(response.data);
      OpenFile.open(filePath);
      // File downloaded successfully
      print('File downloaded to $filePath');
    } catch (e) {
      // Error occurred during download
      print('Error downloading file: $e');
    }
    // dio.download(
    //   url,
    //   savePath,
    //   cancelToken: cancelToken,
    //   deleteOnError: true,
    //   onReceiveProgress: (receivedBytes, totalBytes) {
    //     print("downloading");
    //     print(receivedBytes);
    //     print(totalBytes);
    //     received = receivedBytes;
    //     total = totalBytes;
    //     // onReceiveProgress(receivedBytes, totalBytes);
    //     if (receivedBytes == totalBytes) {
    //       isCompleted = true;
    //       onComplete();
    //     }
    //   },
    // ).catchError((error) {
    //   if (CancelToken.isCancel(error)) {
    //     print('Download canceled');
    //   } else {
    //     print('Download error: $error');
    //     hasError = true; // Set error state
    //     onError(error);
    //   }
    // });
  }

  // Pause the download
  void pause() {
    if (!isCompleted) {
      cancelToken.cancel();

      /// Stop download, but the incomplete data will not be deleted.
      isPaused = true;
    }
  }

  // Resume the download
  void resume() {
    if (isPaused && !isCompleted) {
      cancelToken = CancelToken();
      start();
      // / Remove download, and all the data will be deleted.
      isPaused = false;
    }
  }

  // Cancel the download
  void cancel() {
    /// Stop download, and the incomplete data will be deleted.
    if (!isCompleted) {
      cancelToken.cancel();
    }
  }
}

class QualityOption {
  final String quality;
  final int size;

  QualityOption({
    required this.quality,
    required this.size,
  });
}
