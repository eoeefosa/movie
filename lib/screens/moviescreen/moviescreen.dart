import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:torihd/ads/banner_ad_widget.dart';
import 'package:torihd/provider/downloadprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/moviescreen/widgets/detailcard.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../ads/ad_controller.dart';
import '../../models/movie.dart';
import '../home/widgets/moviecard.dart';

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
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  void _showQualityOptions(
      BuildContext context, String downloadlink, String filename) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              "Choose your preference",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ...[1, 2, 3, 4].map((option) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  print("download started");
                  Navigator.pop(context);
                  // // Start download with selected quality
                  Provider.of<DownloadProvider>(context, listen: false)
                      .startDownload(downloadlink, filename);
                },
                label: const Text("Download"),
                icon: const Icon(Icons.download),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '480P Kali 289 AD[Telugu]',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '687.8mb',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '02:55:45',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  Text(
                    'uploaded by admin',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            );
          }),
          const Text("Tori HD"),
          const Text("© 2024 best place for movie downloads")
        ]);
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .getmovieinfo(widget.type, widget.movieid);
    });
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
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const gap = SizedBox(height: 10);

  // Adverts Widget
  Widget _buildAdvertsWidget() {
    final adsControllerAvailable = context.watch<AdsController?>() != null;

    if (adsControllerAvailable) {
      return const Row(
        children: [
          Expanded(
            child: Center(
              child: BannerAdWidget(),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.movieinfoisloading) {
        return Scaffold(
          appBar: AppBar(),
          body: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildShimmerPlaceholder(),
          ),
        );
      } else {
        return _buildContent(movieProvider);
      }
    });
  }

  Widget _buildShimmerPlaceholder() {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20.h,
            width: 150.w,
            color: Colors.grey,
          ),
        ),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: EdgeInsets.all(8.w),
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey,
            ),
            gap,
            Container(
              height: 20.h,
              width: 100.w,
              color: Colors.grey,
            ),
            gap,
            Container(
              height: 20.h,
              width: double.infinity,
              color: Colors.grey,
            ),
            gap,
            Container(
              height: 20.h,
              width: double.infinity,
              color: Colors.grey,
            ),
            gap,
            Container(
              height: 20.h,
              width: double.infinity,
              color: Colors.grey,
            ),
            gap,
            Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(MovieProvider movieProvider) {
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
        progressIndicatorColor: Colors.red,
        topActions: [
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
          title: Consumer<ProfileManager>(
              builder: (context, profileManager, child) {
            return Text(
              movieProvider.currentmovieinfo?.title ?? "ERROR Getting Movie",
              style: TextStyle(
                color: profileManager.darkMode
                    ? Colors.white
                    : Colors.grey.shade900,
              ),
            );
          }),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.w),
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            label: Text(
              "Download",
              style: TextStyle(
                color: Colors.grey.shade200,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              _showQualityOptions(
                  context,
                  movieProvider.currentmovieinfo?.downloadlink ?? "",
                  movieProvider.currentmovieinfo?.title ?? "No Name");
            },
          ),
        ),
        body: ListView(
          children: [
            player,
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    movieProvider.currentmovieinfo?.title ??
                        "Error getting movie",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                        color: Colors.green.shade900),
                  ),
                )
              ],
            ),
            gap,
            Row(
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700),
                ),
              ],
            ),
            Text(
                movieProvider.currentmovieinfo?.description ?? "Error Getting"),
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            SizedBox(
              height: 250.h,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                children: [
                  TableRow(
                    children: [
                      const Text("Type"),
                      Text(
                        movieProvider.currentmovieinfo?.type ?? "Unknown",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Text("Release Date"),
                      Text(
                        // movieProvider.currentmovieinfo?.releaseDate ??
                        "Unknown",
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Text("Country"),
                      Text(
                        // movieProvider.currentmovieinfo?.country ??
                        "Unknown",
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text("Language"),
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          "English",
                          "Swahili",
                        ].map(
                          (e) {
                            return DetailCard(
                              title: e,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Text("Genre"),
                      Text(
                        // movieProvider.currentmovieinfo?.genre ??
                        "Unknown",
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text("Cast"),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          "Sarah Hassan",
                          "Lenaana Kariba",
                          "Lenaana Kariba",
                        ].map(
                          (e) {
                            return DetailCard(
                              title: e,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text("Source"),
                      Text(movieProvider.currentmovieinfo?.source ?? "Unknown"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            Row(
              children: [
                Text(
                  "Related Movies",
                  style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 300.h,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.w,
                  mainAxisSpacing: 10.w,
                  childAspectRatio: 5 / 3,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: movieProvider.movies.length,
                itemBuilder: (context, index) {
                  final Movie currentmovie = movieProvider.movies[index];
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Videoplayer(
                          movieid: currentmovie.id,
                          type: currentmovie.type,
                          youtubeid: currentmovie.youtubetrailer,
                        ),
                      ),
                    ),
                    child: MovieCard(
                      title: currentmovie.title,
                      imgUrl: currentmovie.movieImgurl,
                      rating: currentmovie.rating,
                      movieid: currentmovie.id,
                      type: currentmovie.type,
                      youtubeid: currentmovie.youtubetrailer,
                      detail: currentmovie.detail,
                      description: currentmovie.description,
                      downloadlink: currentmovie.downloadlink,
                      source: currentmovie.source,
                    ),
                  );
                },
              ),
            ),
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
          ],
        ),
      ),
    );
  }
}
