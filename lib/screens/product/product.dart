import 'dart:ui';

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
  const Videoplayer({super.key});

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

  final mockService = MovieBoxCloneApi();
  @override
  void initState() {
    super.initState();
    _movieFuture = mockService.getmovie();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
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
        future: _movieFuture,
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
                //  _showSnackBar(data)
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
                  player,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
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
                        const Text("Resource Detector"),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: _getStateColor(_playerState),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _playerState.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
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

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockService = MovieBoxCloneApi();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: mockService.getmovie(),
      builder: (context, AsyncSnapshot snapshot) {
        final movies = snapshot.data;

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints.expand(
                        width: 30,
                        height: 35,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: const ColorFilter.srgbToLinearGamma(),
                          image: AssetImage(movies['title_img']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(movies["title"]),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 20,
                        ),
                        Icon(Icons.add),
                      ],
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: ListView(
                  children: [
                    CaroselCard(
                      title: movies["title"],
                      imgUrl: movies['title_img'],
                      ads: false,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
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
                    const Text("Resource Detector"),
                    SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: movies['downloads'].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final downloadinfo = movies['downloads'];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DloadCard(
                                  title: downloadinfo[index]["title"],
                                  duration: downloadinfo[index]["duration"],
                                  size: downloadinfo[index]["size"],
                                  source: downloadinfo[index]["source"],
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DloadCard extends StatelessWidget {
  const DloadCard(
      {super.key,
      required this.title,
      required this.size,
      required this.source,
      required this.duration});
  final String title;
  final double size;
  final String source;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      // padding: const EdgeInsets.all(.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${size}Mb"),
              const SizedBox(
                width: 4,
              ),
              Text(
                secondsToHoursMinutes(duration.toDouble()),
              ),
            ],
          ),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.download,
                size: 12,
              ),
              label: const Text(
                "Download",
                style: TextStyle(),
              ))
        ],
      ),
    );
  }
}
