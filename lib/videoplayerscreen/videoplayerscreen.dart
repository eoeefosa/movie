import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String path;

  const VideoPlayerScreen({super.key, required this.path});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = true;
  bool _controlsVisible = true;
  bool _showPlayButton = true; // Show play button by default
  bool _showPauseButton = false;
  bool _showFeedback = false; // Add state for feedback
  String _feedbackMessage = "";

  @override
  void initState() {
    super.initState();
    var file = File(widget.path);
    _controller = VideoPlayerController.file(file)
      ..setLooping(false)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _controller.play(); // Autoplay
          _showPauseButton = true; // Show pause button initially
          _showPlayButton = false; // Hide play button initially
        });
      });

    // Set preferred orientations to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide play/pause feedback buttons after a delay
    _hidePlayPauseFeedback();
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset orientation preferences
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
        _showPauseButton = true;
        _showPlayButton = false;
      } else {
        _controller.pause();
        _showPlayButton = true;
        _showPauseButton = false;
      }
    });

    // Hide pause button after a brief delay when the video is playing
    if (_isPlaying) {
      _hidePlayPauseFeedback();
    }
  }

  void _rewind() {
    final currentPosition = _controller.value.position;
    final rewindPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(rewindPosition);
  }

  void _forward() {
    final currentPosition = _controller.value.position;
    final forwardPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(forwardPosition);
    _showFeedbacked("+10s"); // Show feedback for fast forward
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }

  void _showFeedbacked(String message) {
    setState(() {
      _feedbackMessage = message;
      _showFeedback = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showFeedback = false;
      });
    });
  }

  void _hidePlayPauseFeedback() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isPlaying) {
        setState(() {
          _showPauseButton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (_isPlaying) {
                    _togglePlayPause(); // Toggle play/pause
                  } else {
                    _toggleControlsVisibility();
                  }
                },
                onDoubleTap: () {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final tapX = MediaQuery.of(context).size.width / 2;

                  if (tapX > screenWidth / 3) {
                    _forward(); // Forward by 10 seconds
                  } else if (tapX < screenWidth / 3) {
                    _rewind(); // Rewind by 10 seconds (optional, if needed)
                  }
                },
                child: Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                ),
              ),
              if (_controlsVisible) ...[
                Positioned(
                  top: 40.0,
                  left: 10.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          // Prevent interaction with the video progress indicator
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 15.h, // Increase the height of the touch area
                          child: VideoProgressIndicator(
                            _controller,
                            padding: const EdgeInsets.all(0.0),
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              backgroundColor: Colors.white,
                              bufferedColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          IconButton(
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white),
                            onPressed: _rewind,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white),
                            onPressed: _forward,
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white),
                            onPressed: _toggleFullScreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: _showPlayButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow,
                            size: 100, color: Colors.white),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _showPauseButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        icon: const Icon(Icons.pause,
                            size: 100, color: Colors.white),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    if (_showFeedback) // Display feedback message
                      Positioned(
                        top: 50,
                        left: MediaQuery.of(context).size.width / 2 - 50,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            color: Colors.black.withOpacity(0.7),
                            child: Text(
                              _feedbackMessage,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
