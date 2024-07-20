
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/whatsapp/home/photoview.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

final Directory _photoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Photos extends StatefulWidget {
  const Photos({super.key});

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    if (!Directory(_photoDir.path).existsSync()) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Whatsapp Photo Status"),
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: const Center(
            child: Text(
              "Install WhatsApp\nYour Friend's Status will be available here.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      );
    } else {
      var imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpeg") && item.endsWith(".jpg"))
          .toList(growable: false);
      if (imageList.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Whatapp Photo Status"),
          ),
          body: Container(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Center(
                child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemBuilder: (context, index) {
                String imgPath = imageList[index];
                return Material(
                  elevation: 8.0,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPhotos(
                              imgPath: imgPath,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: imgPath,
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                        ),
                      )),
                );
              },
              staggeredTileBuilder: (i) =>
                  StaggeredTile.count(2, i.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Whatsapp Photo Status"),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: const Text(
                "Sorry, No Images Found. ",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        );
      }
    }
  }
}
