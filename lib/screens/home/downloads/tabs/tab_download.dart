import 'package:flutter/material.dart';
import 'package:movieboxclone/api/mockapiservice.dart';

import '../../../../movieboxtheme.dart';
import '../../../../utils/constants.dart';

class TabDownload extends StatelessWidget {
  const TabDownload({super.key});

  @override
  Widget build(BuildContext context) {
    final mockservice = MovieBoxCloneApi();
    return FutureBuilder(
        future: mockservice.getsdownloads(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List downloads = snapshot.data;
            return ListView(
              children: [
                Text("Downloaded(${downloads.length})"),
                ...List.generate(
                    downloads.length,
                    (index) => DownloadCard(
                        title: downloads[index]['title'],
                        size: downloads[index]['size'],
                        movieimg: downloads[index]['movieImg'],
                        folder: downloads[index]['folder'],
                        duration: downloads[index]['duration']))
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class DownloadCard extends StatelessWidget {
  const DownloadCard({
    super.key,
    required this.title,
    required this.size,
    required this.movieimg,
    required this.folder,
    required this.duration,
  });

  final String title;
  final double size;
  final String movieimg;
  final String folder;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: screensize.width * 0.3,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints.expand(
                width: 150,
                height: 60,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: const ColorFilter.srgbToLinearGamma(),
                  image: AssetImage(movieimg),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 4,
                    right: 0,
                    child: Text(
                      // TODO: duration to time function
                      secondsToHoursMinutes(duration),
                      style: MovieBoxTheme.darkTextTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: screensize.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text("$size MB"),
                Row(
                  children: [
                    const Icon(
                      Icons.folder,
                    ),
                    Text(folder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
