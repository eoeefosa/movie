import 'dart:ui';

import 'package:dio/dio.dart';

class DownloadTask {
  final String url;
  final String savePath;
  final Dio dio;
  late CancelToken cancelToken;
  late int received;
  late int total;
  late double progress;
  bool isPaused = false;
  bool isCompleted = false;
  bool hasError = false; // Error state

  final Function(int received, int total) onReceiveProgress;
  final VoidCallback onComplete;
  final Function(Object error) onError;

  DownloadTask({
    required this.url,
    required this.savePath,
    required this.dio,
    required this.onReceiveProgress,
    required this.onComplete,
    required this.onError,
  }) {
    cancelToken = CancelToken();
    received = 0;
    total = 0;
    progress = 0.0;
  }

  // Start the download
  void start() {
    dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (receivedBytes, totalBytes) {
        received = receivedBytes;
        total = totalBytes;
        onReceiveProgress(receivedBytes, totalBytes);
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
    if (!isCompleted) {
      cancelToken.cancel();
      isPaused = true;
    }
  }

  // Resume the download
  void resume() {
    if (isPaused && !isCompleted) {
      cancelToken = CancelToken();
      start();
      isPaused = false;
    }
  }

  // Cancel the download
  void cancel() {
    if (!isCompleted) {
      cancelToken.cancel();
    }
  }
}
