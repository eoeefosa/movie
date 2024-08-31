import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torihd/provider/downloadprovider.dart';

import 'widgets/downloadtask.dart';

class Testdownloadprovider extends ChangeNotifier {
  final Dio _dio = Dio();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, DownloadTask> _downloadTasks = {};

  Testdownloadprovider() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_chnnel',
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

  Future<void> startDownload(String url, String fileName) async {
    if (await _requestPermissions()) {
      try {
        final Directory appDir = Directory('/storage/emulated/0/Download/Tori');
        final String filePath = '${appDir.path}/$fileName';

        if (_downloadTasks.containsKey(url)) {
          _downloadTasks[url]!.resume();
        } else {
          final DownloadTask task = DownloadTask(
              url: url,
              savePath: filePath,
              dio: _dio,
              onReceiveProgress: (received, total) {
                _onReceiveProgress(url, received, total);
              },
              onComplete: () {
                _showNotification(fileName, 'Download Completed.');
              },
              onError: (error) {
                _showNotification(fileName, 'Download failed.');
              });

          _downloadTasks[url] = task;
          task.start();
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

  void _onReceiveProgress(String url, int received, int total) {
    if (total != -1) {
      double progress = (received / total * 100);
      _downloadTasks[url]?.progress = progress;
      notifyListeners();
    }
  }
}
