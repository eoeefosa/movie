import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Getstatusprovider extends ChangeNotifier {
  void getStatus() async {
    print("Get status called");
    final status = await Permission.storage.request();
    Directory? directory = await getExternalStorageDirectory();
    if (status.isDenied) {
      Permission.storage.request();
      return;
    }
    if (status.isGranted) {
      print(directory!.path);
    }
  }
}
