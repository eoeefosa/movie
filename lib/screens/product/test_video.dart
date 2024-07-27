
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torihd/screens/product/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../styles/snack_bar.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({super.key});

  @override
  State<Videoplayer> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset(
              'assets/images/ypf.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          title: const Text(
            'Youtube Player Flutter',
            style: TextStyle(color: Colors.white),
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
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  gap,
                  _text('Title', _videoMetaData.title),
                  gap,
                  _text('Channel', _videoMetaData.author),
                  gap,
                  _text('Video Id', _videoMetaData.videoId),
                  gap,
                  Row(
                    children: [
                      _text(
                        'Playback Quality',
                        _controller.value.playbackQuality ?? '',
                      ),
                      const Spacer(),
                      _text(
                        "Playback Rate",
                        '${_controller.value.playbackRate}X ',
                      )
                    ],
                  ),
                  gap,
                  TextField(
                    enabled: _isPlayerReady,
                    controller: _idController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // ignore: unnecessary_string_escapes
                      hintText: 'Enter Youtube <video id> or <link>',
                      fillColor: Colors.blueAccent.withAlpha(20),
                      filled: true,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _idController.clear(),
                      ),
                    ),
                  ),
                  gap,
                  Row(
                    children: [
                      _loadCueButton('LOAD'),
                      const SizedBox(width: 10.0),
                      _loadCueButton('CUE'),
                    ],
                  ),
                  gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.load(_ids[(_ids.indexOf(
                                            _controller.metadata.videoId) -
                                        1) %
                                    _ids.length]);
                              }
                            : null,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      IconButton(
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                            : null,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      IconButton(
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        onPressed: _isPlayerReady
                            ? () => _controller.load(_ids[
                                (_ids.indexOf(_controller.metadata.videoId) +
                                        1) %
                                    _ids.length])
                            : null,
                        icon: const Icon(Icons.skip_next),
                      )
                    ],
                  ),
                  gap,
                  Row(
                    children: [
                      const Text(
                        "Volume",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0.0,
                          max: 100.0,
                          divisions: 10,
                          label: '${(_volume).round()}',
                          onChanged: _isPlayerReady
                              ? (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  gap,
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
          text: '$title :',
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
