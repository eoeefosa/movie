import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadTaskInfo {
  final String id;
  final String url;
  final String filename;
  DownloadTaskStatus status;
  int progress;

  DownloadTaskInfo({
    required this.id,
    required this.url,
    required this.filename,
    this.status = DownloadTaskStatus.undefined,
    this.progress = 0,
  });
}

class DownloadProvider with ChangeNotifier {
  bool filesdownloading = false;
  List<DownloadTaskInfo> _downloads = [];

  List<DownloadTaskInfo> get downloads => _downloads;

  void addDownload(String url, String filename) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: (await getApplicationDocumentsDirectory()).path,
      fileName: filename,
      showNotification: true,
      openFileFromNotification: true,
    );

    final download =
        DownloadTaskInfo(id: taskId!, url: url, filename: filename);
        
    _downloads.add(download);
    notifyListeners();
  }

  void updateDownload(String id, DownloadTaskStatus status, int progress) {
    final download = _downloads.firstWhere((task) => task.id == id);
    download.status = status;
    download.progress = progress;
    notifyListeners();
  }

  void pauseDownload(String id) async {
    await FlutterDownloader.pause(taskId: id);
  }

  void resumeDownload(String id) async {
    await FlutterDownloader.resume(taskId: id);
  }

  void cancelDownload(String id) async {
    await FlutterDownloader.cancel(taskId: id);
  }

  void removeDownload(String id) async {
    await FlutterDownloader.remove(taskId: id, shouldDeleteContent: true);
    _downloads.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
