import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:torihd/ads/ad_controller.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/downloadprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/screens/moviescreen/moviescreen.dart';
import 'package:torihd/screens/moviescreen/widgets/detailcard.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../ads/banner_ad_widget.dart';
import '../../provider/movieprovider.dart';
import '../../styles/snack_bar.dart';
import '../home/widgets/moviecard.dart';

class MoviePreviewScreen extends StatefulWidget {
  final Movie movie;

  const MoviePreviewScreen({super.key, required this.movie});

  @override
  State<MoviePreviewScreen> createState() => _MoviePreviewScreenState();
}

class _MoviePreviewScreenState extends State<MoviePreviewScreen> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.movie.youtubetrailer,
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
        return _buildContent(widget.movie);
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

  Widget _buildContent(Movie movie) {
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
              " (${widget.movie.id})",
              style: TextStyle(
                color: profileManager.themeMode == ThemeModeType.dark
                    ? Colors.white
                    : Colors.grey.shade900,
              ),
            );
          }),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
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
                  context, movie.downloadlink ?? "", movie.title ?? "No Name");
            },
          ),
        ),
        body: ListView(
          children: [
            player,
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          movie.title ?? "Error getting movie",
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
                  Text(movie.description ?? "Error Getting"),
                  gap,
                ],
              ),
            ),
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
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
                          movie.type ?? "Unknown",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text("Release Date"),
                        Text(
                          movie.releasedate ?? "Unknown",
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text("Country"),
                        Text(
                          movie.country ?? "Unknown",
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text("Language"),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: movie.language?.map(
                                (e) {
                                  return DetailCard(
                                    title: e,
                                  );
                                },
                              ).toList() ??
                              [
                                "English",
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
                        const Text("Genre"),
                        Text(
                          movie.genre ?? "Unknown",
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
                          children: movie.cast?.map(
                                (e) {
                                  return DetailCard(
                                    title: e,
                                  );
                                },
                              ).toList() ??
                              [
                                "Unknown",
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
                        Text(movie.source ?? "Unknown"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            gap,
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
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
                ],
              ),
            ),
            SizedBox(
              height:
                  Provider.of<ProfileManager>(context).isAdmin ? 320.h : 300.h,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.w,
                  mainAxisSpacing: 10.w,
                  childAspectRatio: 5 / 3,
                ),
                scrollDirection: Axis.horizontal,
                // itemCount: movieProvider.movies.length,
                itemCount: 3,
                itemBuilder: (context, index) {
                  // final Movie currentmovie = movieProvider.movies[index];
                  final Movie currentmovie = movie;
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Videoplayer(
                          movieid: currentmovie.id!,
                          type: currentmovie.type,
                          youtubeid: currentmovie.youtubetrailer,
                        ),
                      ),
                    ),
                    child: MovieCard(
                      movie: currentmovie,
                      title: currentmovie.title,
                      imgUrl: currentmovie.movieImgurl,
                      rating: currentmovie.rating,
                      movieid: currentmovie.id!,
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

  void _showQualityOptions(
      BuildContext context, String downloadlink, String filename) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                "Choose your preference",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ...[1, 2, 3, 4].map((option) {
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
          ]),
        );
      },
    );
  }
}
