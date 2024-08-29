import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:torihd/provider/downloadtask.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/styles/snack_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  late Future _movieFuture;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false)
          .getmovieinfo(widget.type, widget.movieid);
    });
    print(widget.type);
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
    // Pauses video while navigating to the next page
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const gap = SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.movieinfoisloading) {
        // Show shimmer effect while loading
        return Scaffold(
          appBar: AppBar(),
          body: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: _buildShimmerPlaceholder(),
          ),
        );
      } else {
        // Show the actual content when data is ready
        return _buildContent(movieProvider);
      }
    });
  }

  // Build the shimmer placeholder
  Widget _buildShimmerPlaceholder() {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: 150,
            color: Colors.grey,
          ),
        ),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Container(
              height: 20,
              width: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Build the actual content
  Widget _buildContent(MovieProvider movieProvider) {
    return Scaffold(
      appBar: AppBar(
        title:
            Consumer<ProfileManager>(builder: (context, profileManager, child) {
          return Text(
            movieProvider.currentmovieinfo?.title ?? "ERROR Getting Movie",
            style: TextStyle(
              color:
                  profileManager.darkMode ? Colors.white : Colors.grey.shade900,
            ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
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
            ),
          ),
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (context) => Container(),
                enableDrag: false,
                constraints: const BoxConstraints(
                    maxHeight: 75, maxWidth: double.infinity));
          },
        ),
      ),
      body: YoutubePlayerBuilder(
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
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            _controller.reload();
          },
        ),
        builder: (context, player) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  player,
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
                              fontSize: 24,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700),
                      ),
                    ],
                  ),
                  Text(movieProvider.currentmovieinfo?.description ??
                      "Error Getting"),
                  gap,
                  Table(
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
                          Text("Aug 9, 2024"),
                        ],
                      ),
                      const TableRow(
                        children: [
                          Text("Country"),
                          Text("Kenya"),
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
                          Text("Drama"),
                        ],
                      ),
                      TableRow(
                        decoration: const BoxDecoration(),
                        children: [
                          const Expanded(child: Text("Cast")),
                          Wrap(
                            spacing: 0.0,
                            runSpacing: 0.0,
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
                          Text(movieProvider.currentmovieinfo?.source ??
                              "Unknown"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Relate Movies",
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisSpacing: 10,
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileManager>(builder: (context, profileManager, child) {
      return Card(
        color: profileManager.darkMode
            ? Colors.grey.shade700
            : Colors.grey.shade200,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: TextStyle(
                color: profileManager.darkMode
                    ? Colors.grey.shade100
                    : Colors.grey.shade900),
          ),
        ),
      );
    });
  }
}
