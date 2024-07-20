import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/whatsapp/home/myhome.dart';
import 'package:permission_handler/permission_handler.dart';

class WhatappPage extends StatefulWidget {
  const WhatappPage({super.key});

  @override
  State<WhatappPage> createState() => _PageState();
}

class _PageState extends State<WhatappPage> {
  bool _permissionChecked = false;
  late Future<int> _permissionChecker;

  Future<bool> checkPermission() async {
    bool result = await Permission.photos.request().isGranted;
    print("checking Media location Permission : $result");
    setState(() {
      _permissionChecked = true;
    });
    return result;
  }

  Future<int> requestPermission() async {
    openAppSettings();
    PermissionStatus result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      return 1;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _permissionChecker = (() async {
      int finalPermission = 0;

      print("Initial Values of $_permissionChecked ");
      if (_permissionChecked == false) {
        PermissionStatus result = await Permission.storage.request();
        if (result == PermissionStatus.granted) finalPermission = 1;
      }
      print(finalPermission);
      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _permissionChecker,
        builder: (context, status) {
          print(status);
          if (status.connectionState == ConnectionState.done) {
            if (status.hasData) {
              if (status.data == 1) {
                return const MyHome();
              } else {
                return Scaffold(
                    body: Container(
                  color: Colors.lightBlue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "File Read Permission Required",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _permissionChecker = requestPermission();
                            });
                          },
                          child: const Text(
                            "Allow File Read Permission",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
              }
            } else {
              return Scaffold(
                body: Container(
                  color: Colors.lightBlue,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Something went wrong.. Please unistall and Install Again.",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              body: Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
