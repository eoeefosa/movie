import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../api/mockapiservice.dart';
import '../../styles/snack_bar.dart';
import '../../utils/constants.dart';
import '../home/trending/trending.dart';
import 'video_list.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer(
      {super.key,
      required this.movieid,
      required this.youtubeid,
      required this.type});
  final String movieid;
  final String youtubeid;
  final String type;

  @override
  State<Videoplayer> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late Future _movieFuture;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  final double _volume = 100;
  final bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeid,
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
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
    _idController.dispose();
    _seekToController.dispose();
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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
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
                IconButton(
                  onPressed: () {
                    log('Settings Tapped!');
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller
                    .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
                showsnackBar('Next Video Started!');
              },
            ),
            builder: (context, player) => Scaffold(
              appBar: AppBar(
                // leading: Padding(
                //   padding: const EdgeInsets.only(left: 12.0),
                //   child: Image.asset(
                //     'assets/images/ypf.png',
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
                title: Text(
                  movies["title"],
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const VideoList(),
                          )),
                      icon: const Icon(Icons.video_library))
                ],
              ),
              bottomNavigationBar: ElevatedButton(
                child: const Text("Download"),
                // style: El,
                onPressed: () {},
              ),
              body: ListView(
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
                            Text(movies["title"]),
                            IconButton(
                              onPressed: () {
                                print("hello");
                              },
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movies["title"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                      child: Text(
                                        movies["description"],
                                        overflow: TextOverflow.clip,
                                      ),
                                    )
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
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.save_alt_sharp))
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
                          child: Flexible(
                            child: Text(
                              "${movies["rating"]}",
                            ),
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

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget _loadCueButton(String action) {
    return Expanded(
        child: MaterialButton(
      onPressed: _isPlayerReady
          ? () {
              if (_idController.text.isNotEmpty) {
                var id = YoutubePlayer.convertUrlToId(
                      _idController.text,
                    ) ??
                    '';
                if (action == 'LOAD') _controller.load(id);
                if (action == 'CUE') _controller.cue(id);
                FocusScope.of(context).requestFocus(FocusNode());
              } else {
                showsnackBar('Source can\'t be empty!');
              }
            }
          : null,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(
          action,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
          text: '$title : ',
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w300,
              ),
            )
          ]),
    );
  }
}
