import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:torihd/video_dowloader/models/video_download_model.dart';

import '../../styles/snack_bar.dart';
import '../../widget/video_quality_card.dart';
import '../models/video_quality_model.dart';
import '../repository/video_downlad_repository.dart';
import '../utils/custom_colors.dart';

class Homescreen extends StatefulWidget {
  final VoidCallback onDownloadCompleted;
  const Homescreen({
    super.key,
    required this.onDownloadCompleted,
  });

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _controller = TextEditingController();
  var _progressValue = 0.0;
  var _isDownloading = false;
  List<VideoQualityModel>? _qualities = [];

  VideoDownloadModel? _video;

  bool _isLoading = false;
  bool _isSearching = false;

  int _selectedQualityIndex = 0;
  String _fileName = "";
  VideoType _videoType = VideoType.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter URL Here",
              style: TextStyle(
                fontSize: 20,
                color: CustomColors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              enabled: false,
              cursorWidth: 1,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                filled: true,
                fillColor: CustomColors.appBar,
                suffixIcon: Icon(
                  Icons.download,
                  color: CustomColors.primary,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isSearching) {
                        showsnackBar("Try again later! Searching in progress.");
                      } else if (_isDownloading) {
                        showsnackBar(
                            "Try again later! Downloading in progress.");
                      } else {
                        Clipboard.getData(Clipboard.kTextPlain)
                            .then((value) async {
                          bool hasString = await Clipboard.hasStrings();
                          if (hasString) {
                            if (_controller.text == value!.text) {
                              _showBottomModal();
                            } else {
                              setState(() {
                                _selectedQualityIndex = 0;
                                _videoType = VideoType.none;
                                _isLoading = false;
                                _qualities = [];
                                _video = null;
                                _isLoading = true;
                              });
                              _controller.text = "";
                              _controller.text = value.text!;

                              if (value.text!.isEmpty ||
                                  _controller.text.isEmpty) {
                                showsnackBar("Please Enter Video URL");
                              } else {
                                _setVideoType(value.text!);
                                setState(() => _isSearching = true);
                                await _onLinkPasted(value.text!);
                              }
                            }
                          } else {
                            showsnackBar(
                                "Empty content pasted! Please try again.");
                          }

                          setState(() => _isLoading = false);
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(CustomColors.primary),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Paste Link",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            color: CustomColors.appBar,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isDownloading) {
                        showsnackBar(
                            "Try again later! Downloading in progress.");
                      } else {
                        setState(() {
                          _selectedQualityIndex = 0;
                          _videoType = VideoType.none;
                          _isLoading = false;
                          _qualities = [];
                          _video = null;
                        });
                        _controller.text = "";
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(CustomColors.primary),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Clear Link",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            color: CustomColors.appBar,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : !_isDownloading
                    ? (_qualities != null)
                        ? Container()
                        : _qualities == null
                            ? Text(
                                "hmm, this link looks too complicated for me or either i don't supported it yet... Can you try another one?",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: CustomColors.white,
                                ),
                              )
                            : Container()
                    : Container(),
            _isDownloading
                ? const SizedBox(height: 20)
                : const SizedBox(height: 10),
            _isDownloading
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.appBar,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.downloading,
                                        color: CustomColors.primary),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Downloading",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _fileName.substring(1),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: CustomColors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${_progressValue.toStringAsFixed(0)}%",
                              style: TextStyle(
                                fontSize: 24,
                                color: CustomColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: (_progressValue / 100),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  )
                : Container(),
            _isDownloading ? const SizedBox(height: 20) : Container(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String? get _getFilePrefix {
    switch (_videoType) {
      case VideoType.facebook:
        return "Facebook";
      case VideoType.twitter:
        return "Twitter";
      case VideoType.youtube:
        return "Youtube";
      case VideoType.instagram:
        return "Instagram";
      default:
        return null;
    }
  }

  Future<void> _performDownloading(String url) async {
    Dio dio = Dio();

    var permissions = await [Permission.storage].request();
    if (permissions[Permission.storage]!.isGranted) {
      var dir = await getApplicationDocumentsDirectory();

      setState(() {
        _fileName =
            "/$_getFilePrefix-${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}.mp4";
      });

      var path = dir.path + _fileName;
      try {
        setState(() {
          _isDownloading = true;
        });
        await dio.download(
          url,
          path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _progressValue = (received / total * 100);
              });
            }
          },
          deleteOnError: true,
        ).then((_) async {
          widget.onDownloadCompleted();
          setState(() {
            _isDownloading = false;
            _progressValue = 0.0;
            _videoType = VideoType.none;
            _isLoading = false;
            _qualities = [];
            _video = null;
          });
          _controller.text = "";
          showsnackBar("Video downloaded succesfully.");
        });
      } on DioException catch (e) {
        setState(() {
          _videoType = VideoType.none;
          _isDownloading = false;
          _qualities = [];
          _video = null;
        });
        showsnackBar("Oops! ${e.message}");
      }
    } else {
      showsnackBar("No permission to read and write.");
    }
  }

  void _setVideoType(String url) {
    if (url.isEmpty) {
      setState(() {
        _videoType = VideoType.none;
      });
    } else if (url.contains("facebook.com") || url.contains("fb.watch")) {
      setState(() {
        _videoType = VideoType.facebook;
      });
    } else if (url.contains("youtube.com") || url.contains("youtu.be")) {
      setState(() {
        _videoType = VideoType.youtube;
      });
    } else if (url.contains("twitter.com")) {
      setState(() {
        _videoType = VideoType.instagram;
      });
    } else if (url.contains("instagram.com")) {
      setState(() {
        _videoType = VideoType.instagram;
      });
    } else {
      setState(() {
        _videoType = VideoType.none;
      });
    }
  }

  Future<VideoDownloadModel?> _getExtractionMethod({
    required VideoType type,
    required String url,
  }) async {
    final repository = VideoDownloaderRepository();

    switch (type) {
      case VideoType.facebook:
        return await repository.getAvailableFBVideos(url);
      case VideoType.twitter:
        return await repository.getAvailableTWVideos(url);
      case VideoType.youtube:
        return await repository.getAvailableYTVideos(url);
      case VideoType.instagram:
        return await repository.getAvailableIGVideos(url);
      default:
        return null;
    }
  }

  Future<void> _onLinkPasted(String url) async {
    var response = await _getExtractionMethod(type: _videoType, url: url);
    setState(() => _video = response);
    if (_video != null) {
      for (var _quality in _video!.videos) {
        _qualities!.add(_quality);
      }
      _showBottomModal();
    } else {
      _qualities = null;
    }
    setState(() => _isSearching = false);
  }

  _showBottomModal() {
    showBottomSheet(
      context: context,
      backgroundColor: CustomColors.appBar,
      // isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Video Quality",
                        style: TextStyle(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: CustomColors.primary,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _video!.thumbnail!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: CustomColors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Downloading From ${_getFilePrefix!}",
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.library_add,
                        color: CustomColors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _video!.title!,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: List.generate(
                      _qualities!.length,
                      (index) => VideoQualityCard(
                        isSelected: _selectedQualityIndex == index,
                        model: _qualities![index],
                        onTap: () async {
                          setState(() => _selectedQualityIndex = index);
                        },
                        type: _videoType,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_isDownloading) {
                        showsnackBar(
                            "Try again later! Downloading in progress.");
                      } else {
                        Navigator.pop(context);
                        await _performDownloading(
                          _qualities![_selectedQualityIndex].url!,
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(CustomColors.primary),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Download This Video",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            color: CustomColors.appBar,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
