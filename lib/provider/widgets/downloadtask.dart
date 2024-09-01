import 'dart:ui';

import 'package:al_downloader/al_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  // final Function(int received, int total) onReceiveProgress;
  final Function(double progress) alprogress;
  final VoidCallback onComplete;
  final Function(Object error) onError;

  bool isPaused = false;
  bool isCompleted = false;
  bool hasError = false;

  DownloadTask({
    required this.alprogress,
    required this.fileName,
    required this.url,
    required this.savePath,
    required this.dio,
    // required this.onReceiveProgress,
    required this.onComplete,
    required this.onError,
    required this.qualityOptions, // Initialize quality options
  }) {
    cancelToken = CancelToken();
    received = 0;
    total = 0;
    progress = 0.0;
  }

  void downloadwithAl() {
    ALDownloader.download(url,
        directoryPath: savePath,
        fileName: fileName,
        handlerInterface:
            ALDownloaderHandlerInterface(progressHandler: (alprogress) {
          progress = alprogress;

          debugPrint(
              'ALDownloader | download progress = $progress, url = $url\n');
        }, succeededHandler: () {
          isCompleted = true;
          onComplete();

          debugPrint('ALDownloader | download succeeded, url = $url\n');
        }, failedHandler: () {
          debugPrint('ALDownloader | download failed, url = $url\n');
        }, pausedHandler: () {
          isPaused = true;

          debugPrint('ALDownloader | download paused, url = $url\n');
        }));
  }

// Start the download
  void start() {
    print("Start download clicked");
    dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      deleteOnError: true,
      onReceiveProgress: (receivedBytes, totalBytes) {
        print("downloading");
        print(receivedBytes);
        print(totalBytes);
        received = receivedBytes;
        total = totalBytes;
        // onReceiveProgress(receivedBytes, totalBytes);
        if (receivedBytes == totalBytes) {
          isCompleted = true;
          onComplete();
        }
      },
    ).catchError((error) {
      if (CancelToken.isCancel(error)) {
        print('Download canceled');
      } else {
        print('Download error: $error');
        hasError = true; // Set error state
        onError(error);
      }
    });
  }

  // Pause the download
  void pause() {
    // if (!isCompleted) {
    // cancelToken.cancel();
    /// Stop download, but the incomplete data will not be deleted.
    ALDownloader.pause(url);
    isPaused = true;
    // }
  }

  // Resume the download
  void resume() {
    // if (isPaused && !isCompleted) {
    //   cancelToken = CancelToken();
    //   start();
    /// Remove download, and all the data will be deleted.
    ALDownloader.remove(url);
    isPaused = false;
    // }
  }

  // Cancel the download
  void cancel() {
    /// Stop download, and the incomplete data will be deleted.
    ALDownloader.cancel(url);
    // if (!isCompleted) {
    // cancelToken.cancel();
    // }
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
