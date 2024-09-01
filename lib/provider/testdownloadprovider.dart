// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:torihd/provider/downloadprovider.dart';

// import 'widgets/downloadtask.dart';

// class Testdownloadprovider extends ChangeNotifier {
//   final Dio _dio = Dio();

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final Map<String, DownloadTask> _downloadTasks = {};

//   Testdownloadprovider() {
//     _initializeNotifications();
//   }

//   void _initializeNotifications() {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<bool> _requestPermissions() async {
//     if (Platform.isAndroid) {
//       if (await Permission.storage.request().isGranted) {
//         return true;
//       } else if (await Permission.manageExternalStorage.request().isGranted) {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       return true;
//     }
//   }

//   Future<void> _showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'download_chnnel',
//       'Downloads',
//       channelDescription: 'Notifications for download status',
//       importance: Importance.max,
//       priority: Priority.high,
//       showProgress: true,
//       maxProgress: 100,
//       indeterminate: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }

//   Future<void> startDownload(String url, String fileName) async {
//     if (await _requestPermissions()) {
//       try {
//         final Directory appDir = Directory('/storage/emulated/0/Download/Tori');
//         final String filePath = '${appDir.path}/$fileName';

//         if (_downloadTasks.containsKey(url)) {
//           _downloadTasks[url]!.resume();
//         } else {
//           final DownloadTask task = DownloadTask(
//             fileName: fileName,
//               url: url,
//               savePath: filePath,
//               dio: _dio,
//               onReceiveProgress: (received, total) {
//                 _onReceiveProgress(url, received, total);
//               },
//               onComplete: () {
//                 _showNotification(fileName, 'Download Completed.');
//               },
//               onError: (error) {
//                 _showNotification(fileName, 'Download failed.');
//               }, qualityOptions: []);

//           _downloadTasks[url] = task;
//           task.start();
//         }
//         notifyListeners();
//       } catch (e) {
//         _showNotification(fileName, 'Error: $e');
//         rethrow;
//       }
//     } else {
//       _showNotification(fileName, 'Permission denied.');
//     }
//   }

//   void _onReceiveProgress(String url, int received, int total) {
//     if (total != -1) {
//       double progress = (received / total * 100);
//       _downloadTasks[url]?.progress = progress;
//       notifyListeners();
//     }
//   }
// }


// // class Downloads extends StatefulWidget {
// //   const Downloads({super.key});

// //   @override
// //   State<Downloads> createState() => _DownloadsState();
// // }

// // class _DownloadsState extends State<Downloads> {
// //   late List<VideoData> videoData;
// //   int progress = 0;
// //   ReceivePort receivePort = ReceivePort();

// //   @override
// //   void initState() {
// //     IsolateNameServer.registerPortWithName(
// //         receivePort.sendPort, "dowloadingvideo");

// //     receivePort.listen((message) {
// //       setState(() {
// //         progress = message;
// //         print(progress);
// //       });
// //     });
// //     super.initState();
// //   }

// //   void _showQualityOptions(BuildContext context, DownloadTask task) {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) {
// //         return Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: task.qualityOptions.map((option) {
// //             return ListTile(
// //               title: Text('${option.quality} - ${FileSize.getSize(option.size)}'),
// //               onTap: () {
// //                 Navigator.pop(context);
// //                 // Start download with selected quality
// //                 Provider.of<DownloadProvider>(context, listen: false)
// //                     .startDownload(task.url, task.savePath, option);
// //               },
// //             );
// //           }).toList(),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Download"),
// //       ),
// //       body: Consumer<DownloadProvider>(
// //         builder: (context, downloadProvider, child) {
// //           if (downloadProvider.downloadTasks.isEmpty) {
// //             return const Center(
// //               child: Text("No downloads in progress"),
// //             );
// //           } else {
// //             return ListView.builder(
// //               itemCount: downloadProvider.downloadTasks.length,
// //               padding: const EdgeInsets.symmetric(vertical: 5),
// //               itemBuilder: (context, index) {
// //                 final task = downloadProvider.downloadTasks.values.elementAt(index);
// //                 return Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Column(
// //                     children: [
// //                       Card(
// //                         elevation: 3,
// //                         child: ListTile(
// //                           leading: Icon(
// //                             task.hasError ? Icons.error : Icons.download,
// //                             color: task.hasError ? Colors.red : Colors.blue,
// //                           ),
// //                           title: Text(task.url),
// //                           subtitle: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               LinearProgressIndicator(
// //                                 value: task.progress / 100,
// //                                 color: task.hasError ? Colors.red : Colors.green,
// //                               ),
// //                               SizedBox(height: 8),
// //                               Text('${task.progress.toStringAsFixed(2)}% completed'),
// //                             ],
// //                           ),
// //                           trailing: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               IconButton(
// //                                 icon: Icon(Icons.more_vert),
// //                                 onPressed: () => _showQualityOptions(context, task),
// //                               ),
// //                               if (!task.isCompleted) ...[
// //                                 IconButton(
// //                                   icon: Icon(
// //                                     task.isPaused ? Icons.play_arrow : Icons.pause,
// //                                     color: Colors.blue,
// //                                   ),
// //                                   onPressed: () {
// //                                     task.isPaused
// //                                         ? downloadProvider.resumeDownload(task.url)
// //                                         : downloadProvider.pauseDownload(task.url);
// //                                   },
// //                                 ),
// //                                 IconButton(
// //                                   icon: const Icon(Icons.cancel, color: Colors.red),
// //                                   onPressed: () {
// //                                     downloadProvider.cancelDownload(task.url);
// //                                   },
// //                                 ),
// //                               ],
// //                               if (task.isCompleted) ...[
// //                                 const Icon(Icons.check, color: Colors.green),
// //                               ],
// //                               if (task.hasError) ...[
// //                                 IconButton(
// //                                   icon: const Icon(Icons.refresh, color: Colors.orange),
// //                                   onPressed: () {
// //                                     downloadProvider.startDownload(task.url, task.savePath);
// //                                   },
// //                                 ),
// //                               ],
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       if (task.isCompleted)
// //                         MyThumbnail(
// //                           path: task.savePath,
// //                           data: videoData.firstWhere(
// //                               (data) => data.title == task.url, orElse: () => VideoData()), // Replace with your logic to get video data
// //                           onVideoDeleted: () {
// //                             downloadProvider.cancelDownload(task.url);
// //                           },
// //                         ),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
