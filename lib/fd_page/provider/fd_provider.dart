import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torihd/fd_page/widgets/downloaditem.dart';
import 'package:torihd/fd_page/widgets/item_holder.dart';
import 'package:torihd/fd_page/widgets/task_info.dart';

import '../data/fd_data.dart';

class FdProvider extends ChangeNotifier {
  List<TaskInfo>? _tasks;
  List<TaskInfo>? get tasks => _tasks;
  late List<ItemHolder> _items;
  List<ItemHolder> get items => _items;
  final String _localPath = '/storage/emulated/0/Download/Tori';
  final ReceivePort _port = ReceivePort();

  // Check if used
  late bool _showContent;
  bool get showContent => _showContent;
  late bool _permissionReady;
  bool get permissionReady => _permissionReady;
  late bool _saveInPublicStorage;
  get saveInPublicStorage => _saveInPublicStorage;

  // Initialize FDProvider
  void initiziedfd() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    _showContent = false;
    _permissionReady = false;
    _saveInPublicStorage = false;

    notifyListeners();
  }

  void disposefd() {
    _unbindBackgroundIsolate();
  }

  void setsaveInPublic(bool? value) {
    _saveInPublicStorage = value!;
    notifyListeners();
  }

  @pragma('vm:entry_point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    print(
      'Callback on background isolate:'
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  void retryRequestPermission() async {
    final hasGranted = await _checkPermission();
    if (hasGranted) {
      await _prepareSaveDir();
    }
    _permissionReady = hasGranted;
    notifyListeners();
  }

  void requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      savedDir: _localPath,
      // headers: {'auth': 'test_for_sql_enco÷ding'},
      saveInPublicStorage: _saveInPublicStorage,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
  }

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      print('No task were retrieved for the database. ');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks!.addAll(
      DownloadItems.documents.map(
        (document) => TaskInfo(name: document.name, link: document.url),
      ),
    );

    _items.add(ItemHolder(name: 'Documents'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.images
          .map((image) => TaskInfo(name: image.name, link: image.url)),
    );

    _items.add(ItemHolder(name: 'Images'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.videos
          .map((video) => TaskInfo(name: video.name, link: video.url)),
    );

    _items.add(ItemHolder(name: 'Videos'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.apks
          .map((video) => TaskInfo(name: video.name, link: video.url)),
    );

    _items.add(ItemHolder(name: 'APKs'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
    }

    _showContent = true;
  }

  Future<void> _prepareSaveDir() async {
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      print(
        'callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        task
          ..status = status
          ..progress = progress;
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
