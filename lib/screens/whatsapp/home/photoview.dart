import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;
  const ViewPhotos({super.key, required this.imgPath});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  var filePath;

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const CircularProgressIndicator(),
                  ),
                ),
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
        title: Center(
          child: TextButton.icon(
            icon: const Icon(Icons.file_download), //`Icon` to display
            label: const Text(
              'Download',
              style: TextStyle(fontSize: 20.0),
            ), //`Text` to display
            onPressed: () async {
              _onLoading(true, "");
              File originalImageFile1 = File(widget.imgPath);

              Directory? directory = await getExternalStorageDirectory();
              if (!Directory("${directory!.path}/Downloaded Status/Images")
                  .existsSync()) {
                Directory("${directory.path}/Downloaded Status/Images")
                    .createSync(recursive: true);
              }
              String? path = directory.path;
              String curDate = DateTime.now().toString();
              String newFileName =
                  "$path/Downloaded Status/Images/IMG-$curDate.jpg";
              print(newFileName);
              await originalImageFile1.copy(newFileName);

              Uri myUri = Uri.parse(widget.imgPath);
              File originalImageFile = File.fromUri(myUri);
              Uint8List bytes;
              await originalImageFile.readAsBytes().then((value) async {
                bytes = Uint8List.fromList(value);
                print('reading of bytes is completed');
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(bytes));
                print(result);
              }).catchError((onError) {
                print('Exception Error while reading audio from path:$onError');
              });
              _onLoading(false,
                  "If Image not available in gallary\n\nYou can find all images at");
            },
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
