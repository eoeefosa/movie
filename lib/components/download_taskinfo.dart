import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/appState/downloadtask.dart';

// enum DownloadTaskStatus { undefined, downloading, completed, failed }

// class DownloadTaskInfo {
//   final String id;
//   final String url;
//   final String filename;
//   DownloadTaskStatus status;
//   int progress;

//   DownloadTaskInfo({
//     required this.id,
//     required this.url,
//     required this.filename,
//     this.status = DownloadTaskStatus.undefined,
//     this.progress = 0,
//   });
// }

class DownloadTaskCard extends StatelessWidget {
  final DownloadTaskInfo taskInfo;

  const DownloadTaskCard({super.key, required this.taskInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task ID: ${taskInfo.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('URL: ${taskInfo.url}'),
            const SizedBox(height: 8),
            Text('Filename: ${taskInfo.filename}'),
            const SizedBox(height: 8),
            Text('Status: ${_statusToString(taskInfo.status)}'),
            const SizedBox(height: 8),
            Text('Progress: ${taskInfo.progress}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: taskInfo.progress / 100,
              backgroundColor: Colors.grey[200],
              color: _getProgressColor(taskInfo.status),
            ),
          ],
        ),
      ),
    );
  }

  String _statusToString(DownloadTaskStatus status) {
    return status.toString();
    // switch (status) {
    //   case DownloadTaskStatus.:
    //     return 'Downloading';
    //   case DownloadTaskStatus.completed:
    //     return 'Completed';
    //   case DownloadTaskStatus.failed:
    //     return 'Failed';
    //   default:
    //     return 'Undefined';
    // }
  }

  Color _getProgressColor(DownloadTaskStatus status) {
    switch (status) {
      case DownloadTaskStatus.complete:
        return Colors.green;
      case DownloadTaskStatus.failed:
        return Colors.red;
      case DownloadTaskStatus.running:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     DownloadTaskInfo taskInfo = DownloadTaskInfo(
//       id: '12345',
//       url: 'https://example.com/file.zip',
//       filename: 'file.zip',
//       status: DownloadTaskStatus.downloading,
//       progress: 45,
//     );

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Download Task Card')),
//         body: Center(
//           child: DownloadTaskCard(taskInfo: taskInfo),
//         ),
//       ),
//     );
//   }
// }
