import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:torihd/video_dowloader/utils/custom_colors.dart';
import 'package:torihd/widget/my_thumbnail.dart';

class DownloadScreen extends StatefulWidget {
  final List<VideoData> videoData;
  final List<FileSystemEntity?> downloads;
  final VoidCallback onVideoDeleted;
  final ValueChanged<int> onCardTap;
  const DownloadScreen({
    super.key,
    required this.videoData,
    required this.downloads,
    required this.onVideoDeleted,
    required this.onCardTap,
  });

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  _showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: CustomColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    Widget continueButton = TextButton(
        onPressed: () async {
          try {
            final file = File(widget.downloads[index]!.path);
            await file.delete();
          } catch (e) {
            debugPrint(e.toString());
          }
          Navigator.of(context, rootNavigator: true).pop('dialog');
          widget.onVideoDeleted();
        },
        child: Text(
          "Delete",
          style: TextStyle(
            color: CustomColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ));

    AlertDialog alertDialog = AlertDialog(
      backgroundColor: CustomColors.background,
      title: Text(
        "Delete Confirmation",
        style: TextStyle(
          color: CustomColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this video ?",
        style: TextStyle(
          color: CustomColors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.downloads.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 50,
                  color: CustomColors.primary,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Hmm.... it seems like you have no downloaded videos. Please download  some videos and come back later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: CustomColors.white,
                      fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: widget.downloads.length,
              padding: const EdgeInsets.symmetric(vertical: 5),
              itemBuilder: (context, index) {
                int reverseIndex = widget.downloads.length - 1 - index;
                return InkWell(
                  onTap: () => widget.onCardTap(reverseIndex),
                  child: MyThumbnail(
                    path: widget.downloads[reverseIndex]!.path,
                    data: widget.videoData[reverseIndex],
                    onVideoDeleted: () {
                      _showAlertDialog(context, reverseIndex);
                    },
                  ),
                );
              },
            ),
          );
  }
}
