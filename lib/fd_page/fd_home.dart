import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:torihd/fd_page/provider/fd_provider.dart';
import 'package:torihd/fd_page/widgets/download_list_item.dart';
import 'package:torihd/styles/snack_bar.dart';

import 'widgets/task_info.dart';

class FdHome extends StatefulWidget {
  const FdHome({super.key});

  @override
  State<FdHome> createState() => _FdHomeState();
}

class _FdHomeState extends State<FdHome> {

  @override
  void initState(){

    
    super.initState();
  

  }
  
  
  Widget _buildDownloadList() {
    return Consumer<FdProvider>(builder: (context, fdprovider, child) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Row(
            children: [
              Checkbox(
                  value: fdprovider.saveInPublicStorage,
                  onChanged: (newValue) {
                    fdprovider.setsaveInPublic(newValue);
                  }),
              const Text("Save in public storage"),
            ],
          ),
          ...fdprovider.items.map((item) {
            final task = item.task;

            if (task == null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return DownloadListItem(
              data: item,
              onTap: (task) async {
                final success = await _openDownloadedFile(task);

                if (!success) {
                  showsnackBar("Cannot open this file");
                }
              },
              onActionTap: (task) {
                if (task.status == DownloadTaskStatus.undefined) {
                  Provider.of<FdProvider>(context, listen: false)
                      .requestDownload(task);
                } else if (task.status == DownloadTaskStatus.running) {
                  Provider.of<FdProvider>(context, listen: false)
                      .pauseDownload(task);
                } else if (task.status == DownloadTaskStatus.canceled) {
                  Provider.of<FdProvider>(context, listen: false).delete(task);
                } else if (task.status == DownloadTaskStatus.failed) {
                  Provider.of<FdProvider>(context, listen: false)
                      .retryDownload(task);
                }
              },
              onCancel: Provider.of<FdProvider>(context, listen: false).delete,
            );
          })
        ],
      );
    });
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage Permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          TextButton(
              onPressed:
                  Provider.of<FdProvider>(context).retryRequestPermission,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) async {
    final taskId = task?.taskId;
    if (taskId == null) {
      return false;
    }
    return FlutterDownloader.open(taskId: taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download page"),
        actions: [
          if (Platform.isIOS)
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => exit(0),
                  child: const Text(
                    'Simulate App Backgrounded',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            )
        ],
      ),
      body: Consumer<FdProvider>(
        builder: (context, fdprovider, child) {
          if (!fdprovider.showContent) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return fdprovider.permissionReady
              ? _buildDownloadList()
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}
