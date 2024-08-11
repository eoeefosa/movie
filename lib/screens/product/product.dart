import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:torihd/models/appState/downloadtask.dart';
import 'package:torihd/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/movie.dart';
import '../../provider/movieprovider.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({
    super.key,
    required this.movieid,
    required this.youtubeid,
    required this.type,
  });
  final String movieid;
  final String youtubeid;
  final String type;

  @override
  State<Videoplayer> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late YoutubePlayerController _controller;
  late Future _movieFuture;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    print(widget.type);
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeid,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        enableCaption: false,
      ),
    );

    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _idController.dispose();
    // _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(
      height: 10,
    );
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(widget.type)
            .doc(widget.movieid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('No data available'),
              ),
            );
          }

          final movies = snapshot.data!;

          return YoutubePlayerBuilder(
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
            onExitFullScreen: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blue,
              topActions: [
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller.reload();
              },
            ),
            builder: (context, player) => Scaffold(
              appBar: AppBar(
                title: Text(
                  movies["title"],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              bottomNavigationBar: ElevatedButton(
                child: const Text("Download"),
                onPressed: () {
                  // context.go('/home/1');]

                  final downloadUrl = movies["downloadlink"];
                  final filename = movies["title"];
                  Provider.of<DownloadProvider>(context, listen: false)
                      .addDownload(downloadUrl, filename);
                  hideSnackBar();
                  showsnackBar("${movies["title"]} started downloading");
                },
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        player,
                        gap,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(movies["title"]),
                        //     IconButton(
                        //       onPressed: () {
                        //         // print("hello");
                        //       },
                        //       icon: const Icon(Icons.favorite),
                        //     )
                        //   ],
                        // ),
                        gap,
                        SizedBox(
                          height: height / 7,
                          child: Row(
                            children: [
                              SizedBox(
                                width: width * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movies["title"] ?? 7.5,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Consumer<DownloadProvider>(builder:
                                        (context, movieProvider, child) {
                                      return movieProvider.progress == null
                                          ? Text(movies["detail"])
                                          : Flexible(
                                              child: Text(
                                                "${movieProvider.progress}",
                                                overflow: TextOverflow.clip,
                                              ),
                                            );
                                    })
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: width * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        "${movies["rating"]}",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        gap,
                        const Row(
                          children: [
                            Text("Description"),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: Text(
                            movies["description"],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
