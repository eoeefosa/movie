import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/models/season.dart';
import 'package:torihd/provider/downloadprovider.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/moviescreen/widgets/advert_widgets.dart';
import 'package:torihd/screens/moviescreen/widgets/download_button.dart';
import 'package:torihd/screens/moviescreen/widgets/movie_details.dart';
import 'package:torihd/screens/moviescreen/widgets/movie_metadata.dart';
import 'package:torihd/screens/moviescreen/widgets/related_movie.dart';
import 'package:torihd/screens/moviescreen/widgets/season_dropdown.dart';
import 'package:torihd/screens/moviescreen/widgets/shimmer_placeholder.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Viewmovies extends StatefulWidget {
  const Viewmovies({
    super.key,
    required this.movieid,
    required this.youtubeid,
    required this.type,
  });
  final String movieid;
  final String youtubeid;
  final String type;

  @override
  State<Viewmovies> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Viewmovies> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  int selectedSeason = 0;
  late List<Episode> currentEpisodes;

  @override
  void initState() {
    String videoid =
        YoutubePlayer.convertUrlToId(widget.movieid) ?? widget.movieid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .getmovieinfo(widget.type, widget.movieid);
    });
    _controller = YoutubePlayerController(
      // initialVideoId: widget.youtubeid,
      initialVideoId: videoid,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.movieinfoisloading) {
        return Scaffold(
          appBar: AppBar(),
          body: const ShimmerPlaceholder(), // Using the reusable shimmer widget
        );
      } else {
        return _buildContent(movieProvider);
      }
    });
  }

  Widget _buildContent(MovieProvider movieProvider) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () => _isPlayerReady = true,
        onEnded: (_) => _controller.reload(),
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(movieProvider.currentmovieinfo?.title ?? "Error"),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: DownloadButton(
            label: "Download",
            icon: Icons.download,
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
            const SizedBox(height: 10),
            const AdvertsWidget(), // Adverts widget
            MovieDetails(movieProvider: movieProvider),
            const AdvertsWidget(), // Adverts widget
            movieProvider.currentmovieinfo?.seasons != null
                ? SeasonDropdown(
                    tvSeries: movieProvider.currentmovieinfo!,
                    selectedSeason: selectedSeason,
                    onSeasonSelected: (newSeason) {
                      setState(() {
                        selectedSeason = newSeason;
                      });
                    },
                  )
                : Container(),
            const SizedBox(height: 10),
            movieProvider.currentmovieinfo?.seasons != null
                ? _buildEpisodeList(
                    movieProvider.currentmovieinfo!, selectedSeason)
                : Container(),
            movieProvider.currentmovieinfo?.seasons != null
                ? const AdvertsWidget()
                : Container(), // Insert Ad Widget here
            const SizedBox(height: 10),
            MovieMetadata(
              movieProvider: movieProvider,
            ),
            SizedBox(height: 20.h),
            RelatedMovie(movieProvider: movieProvider)
          ],
        ),
      ),
    );
  }

  int? _selectedEpisodeIndex; // Holds the index of the selected episode
  int _season = 1;

  Widget _buildEpisodeList(Movie tvseries, int season) {
    _season = season; // Update current season state
    return SizedBox(
      height: 100.h, // Height of the scrolling episode list
      child: Wrap(
        spacing: 8.w, // Space between episode items
        children: List.generate(
          tvseries.seasons![_season].episodes.length,
          (index) {
            bool isSelected = _selectedEpisodeIndex ==
                index; // Check if the episode is selected
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedEpisodeIndex = index; // Set the selected episode
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green
                      : Colors.red, // Color based on selection
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  'Episode ${tvseries.seasons![_season].episodes[index].episodeNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
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
                              if (movieprovider.currentmovieinfo?.type ==
                                  "movie") {
                                Provider.of<DownloadProvider>(context,
                                        listen: false)
                                    .startDownload(downloadlink, filename);
                              } else {
                                Provider.of<DownloadProvider>(context,
                                        listen: false)
                                    .startDownload(
                                        movieprovider
                                            .currentmovieinfo!
                                            .seasons![_season]
                                            .episodes[_selectedEpisodeIndex!]
                                            .downloadLinks![0]
                                            .url,
                                        filename);
                              }
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
