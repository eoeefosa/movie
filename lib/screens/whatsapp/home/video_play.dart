import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import 'video_controller.dart';

class PlayStatusVideo extends StatefulWidget {
  final String videoFile;
  const PlayStatusVideo({super.key, required this.videoFile});

  @override
  State<PlayStatusVideo> createState() => _PlayStatusVideoState();
}

class _PlayStatusVideoState extends State<PlayStatusVideo> {
  @override
  void initState() {
    super.initState();
    print("here is what you looking for:${widget.videoFile}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _OnLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const CircularProgressIndicator(),
                  ),
                )
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Great, Saved in Gallary",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Text("FileManager > Downloaded Status",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
          child: TextButton.icon(
            icon: const Icon(Icons.file_download),
            label: const Text(
              'Download',
              style: TextStyle(fontSize: 16.0),
            ), //`Text` to display
            onPressed: () async {
              _OnLoading(true, "");

              File originalVideoFile = File(widget.videoFile);
              Directory? directory = await getExternalStorageDirectory();
              if (!Directory("${directory!.path}/Downloaded Status/Videos")
                  .existsSync()) {
                Directory("${directory.path}/Downloaded Status/Videos")
                    .createSync(recursive: true);
              }
              String? path = directory.path;
              String curDate = DateTime.now().toString();
              String newFileName =
                  "$path/Downloaded Status/Videos/VIDEO-$curDate.mp4";
              print(newFileName);
              await originalVideoFile.copy(newFileName);

              _OnLoading(false,
                  "If Video not available in gallary\n\nYou can find all videos at");
            },
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        StatusVideo(
          videoPlayerController:
              VideoPlayerController.file(File(widget.videoFile)),
          looping: true,
          videoSrc: widget.videoFile,
        )
      ]),
    );
  }
}
