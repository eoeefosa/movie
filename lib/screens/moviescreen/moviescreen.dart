import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:torihd/ads/banner_ad_widget.dart';
import 'package:torihd/models/season.dart';
import 'package:torihd/provider/downloadprovider.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/moviescreen/widgets/detailcard.dart';
import 'package:torihd/screens/moviescreen/widgets/movie_metadata.dart';
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

  Widget _buildEpisodeList(Movie tvseries, int season) {
    return SizedBox(
      height: 100.h, // Height of the scrolling episode list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvseries.seasons![season].episodes.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Card(
              child: Column(
                children: [
                  Text(
                    tvseries.seasons![season].episodes[index].title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _downloadSingleEpisode(
                          tvseries.seasons![season].episodes[index]);
                    },
                    child: const Text("Download"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _downloadSingleEpisode(Episode episode) {
    String downloadLink =
        episode.downloadLinks![0].url; // Get the download link for the episode
    String filename = "${episode.title}.mp4"; // Set filename
    Provider.of<DownloadProvider>(context, listen: false)
        .startDownload(downloadLink, filename);
  }

  void _downloadAllEpisodes(Movie tvSeriesProvider, int season) {
    List<Episode> episodes = tvSeriesProvider.seasons![season].episodes;
    for (Episode episode in episodes) {
      String downloadLink =
          episode.downloadLinks![0].url; // Get the download link for the episode
      String filename = "${episode.title}.mp4"; // Set filename
      Provider.of<DownloadProvider>(context, listen: false)
          .startDownload(downloadLink, filename);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading all episodes of $season")),
    );
  }

  void _downloadAllSeasons(Movie tvSeriesProvider) {
    for (int season = 1; season <= tvSeriesProvider.seasons!.length; season++) {
      List<Episode> episodes = tvSeriesProvider.seasons![season].episodes;
      for (Episode episode in episodes) {
        String downloadLink = episode
            .downloadLinks![0].url; // Get the download link for the episode
        String filename = "${episode.title}.mp4"; // Set filename
        Provider.of<DownloadProvider>(context, listen: false)
            .startDownload(downloadLink, filename);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Downloading all episodes of all seasons")),
    );
  }

  Widget _buildDownloadOptions(Movie tvSeriesProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _downloadAllEpisodes(tvSeriesProvider, selectedSeason);
          },
          child: const Text("Download All"),
        ),
        ElevatedButton(
          onPressed: () {
            _downloadAllSeasons(tvSeriesProvider);
          },
          child: const Text("Download All Seasons"),
        ),
      ],
    );
  }

  late List<Episode> currentEpisodes;

  Widget _buildSeasonDropdown(Movie tvSeriesProvider) {
    return DropdownButton<int>(
      value: selectedSeason,
      onChanged: (int? newValue) {
        setState(() {
          selectedSeason = newValue!;
          currentEpisodes = tvSeriesProvider.seasons![selectedSeason].episodes;
        });
      },
      items:
          tvSeriesProvider.seasons!.map<DropdownMenuItem<int>>((Season season) {
        return DropdownMenuItem<int>(
          value: season.seasonNumber,
          child: Text("Season $season"),
        );
      }).toList(),
    );
  }

  int selectedSeason = 0;

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
                context,
                movieProvider.currentmovieinfo?.downloadlink ?? "",
                movieProvider.currentmovieinfo?.title ?? "No Name",
                movieProvider,
              );
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
                  Text(movieProvider.currentmovieinfo?.description ??
                      "Error Getting"),
                  gap,
                ],
              ),
            ),
            _buildAdvertsWidget(), // Insert Ad Widget here
            gap,
            movieProvider.currentmovieinfo?.seasons != null
                ? _buildSeasonDropdown(movieProvider.currentmovieinfo!)
                : Container(),
            gap,
            movieProvider.currentmovieinfo?.seasons != null
                ? _buildEpisodeList(
                    movieProvider.currentmovieinfo!, selectedSeason)
                : Container(),
            gap,
            movieProvider.currentmovieinfo?.seasons != null
                ? _buildAdvertsWidget()
                : Container(), // Insert Ad Widget here
            gap,
            MovieMetadata(
              movieProvider: movieProvider,
            ),
            SizedBox(height: 20.h),
            gap,
            SizedBox(
                height: 50.h,
                child: _buildAdvertsWidget()), // Insert Ad Widget here
            gap,
            Column(
              children: [
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
                  height: Provider.of<ProfileManager>(context).isAdmin
                      ? 320.h
                      : 300.h,
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
                          source: currentmovie.source,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _buildAdvertsWidget(), // Insert Ad Widget here
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityOptions(BuildContext context, String downloadlink,
      String filename, MovieProvider movieprovider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  "Choose your preference",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Consumer<DownloadProvider>(
                builder: (context, downloadProvider, child) {
                  final task = downloadProvider.downloadTasks[filename];

                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    trailing: task != null
                        ? task.isCompleted
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  // Play the downloaded file
                                  Navigator.pop(context);
                                  // Logic to play the downloaded file goes here
                                },
                                label: const Text("Play"),
                                icon: const Icon(Icons.play_arrow),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${task.progress.toStringAsFixed(2)}% completed',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: LinearProgressIndicator(
                                      value: task.progress / 100,
                                    ),
                                  ),
                                ],
                              )
                        : ElevatedButton.icon(
                            onPressed: () {
                              // Start the download
                              Navigator.pop(context);
                              Provider.of<DownloadProvider>(context,
                                      listen: false)
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
                          'link 1',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Text("Tori HD"),
              const Text("© 2024 best place for movie downloads")
            ],
          ),
        );
      },
    );
  }
}
