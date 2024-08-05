import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torihd/video_dowloader/screens/download_screen.dart';
import 'package:torihd/video_dowloader/screens/homeScreen.dart';
import 'package:torihd/video_dowloader/utils/custom_colors.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final PageController _pageController = PageController();
  final FileManagerController controller = FileManagerController();
  List<VideoData> _videoData = [];
  List<FileSystemEntity?> _downloads = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _getDownloads() async {
    setState(() {
      _downloads = [];
      _videoData = [];
    });

    final videoInfo = FlutterVideoInfo();
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    final myDir = Directory(dir);

    List<FileSystemEntity> folder =
        myDir.listSync(recursive: true, followLinks: false);

    List<FileSystemEntity> data = [];

    for (var item in folder) {
      if (item.path.contains(".mp4")) {
        data.add(item);
        var info = await videoInfo.getVideoInfo(item.path);
        _videoData.add(info!);
      }
    }
    setState(() {
      _downloads = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text(
          "HM video Downloader",
          style: TextStyle(
            color: CustomColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: CustomColors.background,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Homescreen(
            onDownloadCompleted: () => _getDownloads(),
          ),
          DownloadScreen(
            downloads: _downloads,
            videoData: _videoData,
            onVideoDeleted: () => _getDownloads(),
            onCardTap: (index) {
              setState(() {
                _selectedIndex = 2;
              });

              _pageController.jumpToPage(_selectedIndex);
            },
          ),
          const SizedBox(),
          const SizedBox(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: CustomColors.background,
        bottomPadding: 12,
        waterDropColor: CustomColors.primary,
        inactiveIconColor: CustomColors.primary,
        iconSize: 29,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        selectedIndex: _selectedIndex,
        barItems: [
          BarItem(filledIcon: Icons.home, outlinedIcon: Icons.home_outlined),
          BarItem(
              filledIcon: Icons.file_download,
              outlinedIcon: Icons.file_download_outlined),
          BarItem(
              filledIcon: Icons.video_library,
              outlinedIcon: Icons.video_library_outlined),
          BarItem(filledIcon: Icons.info, outlinedIcon: Icons.info_outlined),
        ],
      ),
    );
  }
}
