import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../styles/snack_bar.dart';

class MoviePreviewScreen extends StatefulWidget {
  final String movieTitle;
  final String movieDescription;
  final String downloadLink;
  final String youtubeTrailerLink;
  final String category;
  final String imagePath;
  final String rating;

  const MoviePreviewScreen({
    required this.movieTitle,
    required this.movieDescription,
    required this.downloadLink,
    required this.youtubeTrailerLink,
    required this.category,
    required this.imagePath,
    super.key,
    required this.rating,
  });

  @override
  State<MoviePreviewScreen> createState() => _MoviePreviewScreenState();
}

class _MoviePreviewScreenState extends State<MoviePreviewScreen> {
  late YoutubePlayerController _controller;

  late Future _movieFuture;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeTrailerLink,
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
    return YoutubePlayerBuilder(
        onEnterFullScreen: () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                  widget.movieTitle,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              bottomNavigationBar: ElevatedButton(
                child: const Text("Download"),
                onPressed: () {
                  // context.go('/home/1');]
                  final downloadUrl = widget.downloadLink;
                  final filename = widget.movieTitle;
                  // Provider.of<DownloadProvider>(context, listen: false)
                  //     .addDownload(downloadUrl, filename);
                  hideSnackBar();
                  showsnackBar("${widget.movieTitle} started downloading");
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          player,
                          gap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.movieTitle),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite),
                              )
                            ],
                          ),
                          gap,
                          SizedBox(
                            height: height / 7,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.rating,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Flexible(
                                      //   child: Text(
                                      //     movies["details"],
                                      //     overflow: TextOverflow.clip,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Text(
                                          widget.rating,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon:
                                              const Icon(Icons.save_alt_sharp))
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
                              widget.movieDescription,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
