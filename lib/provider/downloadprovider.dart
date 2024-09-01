import 'dart:io';
import 'dart:isolate';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart'; // for getting the download directory
import 'package:permission_handler/permission_handler.dart';

import 'widgets/downloadtask.dart'; // for managing permissions

class DownloadProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Map<String, DownloadTask> _downloadTasks = {};

  DownloadProvider() {
    _initializeNotifications();
  }

  // Initialize local notifications
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Add your app icon in android/app/src/main/res/drawable

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request storage permissions
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  // Start a download task
  Future<void> startDownload(String url, String fileName) async {
    url =
        "https://ma4re4qwfh.b34zobxzxs73nkfxike1.cfd/res/6055fe40123fab85e251b371f5265d13/1a626ea8cd7b95132db112a46edc8fec/Mark_Antony_(2023)_WEBRip_high_(fzmovies.net)_bbeda1b00668b2aaf4cb158af59f82d4.mp4?fromwebsite";

    if (await _requestPermissions()) {
      try {
        // final Directory appDir = await getApplicationDocumentsDirectory();
        final Directory appDir = Directory('/storage/emulated/0/Download/Tori');
        final String filePath = '${appDir.path}/$fileName';

        if (_downloadTasks.containsKey(url)) {
          // Resume an existing download
          _downloadTasks[url]!.resume();
        } else {
          // Create a new download task
          final DownloadTask task = DownloadTask(
            fileName: "$fileName.mp4",
            // url: url,
            url: url,
            savePath: filePath,
            dio: _dio,

            // onReceiveProgress: (received, total) {
            //   _onReceiveProgress(url, received, total);
            // },
            onComplete: () {
              _showNotification(fileName, 'Download completed.');
            },
            onError: (error) {
              _showNotification(fileName, 'Download failed.');
            },
            qualityOptions: [],
            alprogress: (double progress) {
              _alprogress(url, progress);
            },
          );

          _downloadTasks[url] = task;
          task.downloadwithAl();
        }

        notifyListeners();
      } catch (e) {
        _showNotification(fileName, 'Error: $e');
        rethrow;
      }
    } else {
      _showNotification(fileName, 'Permission denied.');
    }
  }

  // Pause a download task
  void pauseDownload(String url) {
    if (_downloadTasks.containsKey(url)) {
      _downloadTasks[url]!.pause();
      notifyListeners();
    }
  }

  // Resume a download task
  void resumeDownload(String url) {
    if (_downloadTasks.containsKey(url)) {
      _downloadTasks[url]!.resume();
      notifyListeners();
    }
  }

  // Cancel a download task
  void cancelDownload(String url) {
    if (_downloadTasks.containsKey(url)) {
      _downloadTasks[url]!.cancel();
      _downloadTasks.remove(url);
      notifyListeners();
    }
  }

  // Handle download progress updates
  void _onReceiveProgress(String url, int received, int total) {
    if (total != -1) {
      double progress = (received / total * 100);
      _downloadTasks[url]?.progress = progress;
      notifyListeners();
    }
  }

  void _alprogress(String url, double progress) {
    _downloadTasks[url]?.progress = progress;

    notifyListeners();
  }

  // Show local notification
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notifications for download status',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      indeterminate: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Get download tasks for UI
  Map<String, DownloadTask> get downloadTasks => _downloadTasks;
}
