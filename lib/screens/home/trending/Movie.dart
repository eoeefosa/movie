import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:torihd/models/appState/profile_manager.dart';
// import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/product/product.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:torihd/screens/upload/uploadmovie.dart';

import '../../../models/movie.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MovieswithProvider(),
    );
  }
}

class MovieswithProvider extends StatefulWidget {
  const MovieswithProvider({super.key});

  @override
  _MovieswithProviderState createState() => _MovieswithProviderState();
}

class _MovieswithProviderState extends State<MovieswithProvider> {
  @override
  void initState() {
    super.initState();
    // Fetch movies after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchmovie();
    });
  }

  Future<void> _refreshTrendingData() async {
    Provider.of<MovieProvider>(context, listen: false).fetchTrendingCarousel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.movieisloading) {
        return const Center(child: CircularProgressIndicator());
      } else if (movieProvider.movies.isEmpty) {
        return const Center(
          child: Text("No Movies available"),
        );
      } else {
        final List<Movie> movies = movieProvider.movies;
        return RefreshIndicator(
          onRefresh: _refreshTrendingData,
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final Movie movie = movies[index];

              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Videoplayer(
                      movieid: movie.id,
                      type: movie.type,
                      youtubeid: movie.youtubetrailer,
                    ),
                  ),
                ),
                child: MovieCard(
                  title: movie.title,
                  type: movie.type,
                  // type: "movies",
                  imgUrl: movie.movieImgurl,
                  rating: movie.rating,
                  youtubeid: movie.youtubetrailer,
                  movieid: movie.id,
                  description: movie.description,
                  detail: movie.detail,
                  downloadlink: movie.downloadlink,
                  source: movie.source,
                ),
              );
            },
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        );
      }
    });
  }
}

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.rating,
    required this.movieid,
    required this.type,
    required this.youtubeid,
    required this.detail,
    required this.description,
    required this.downloadlink,
    required this.source,
  });

  final String title;
  final String imgUrl;
  final String rating;
  final String movieid;
  final String detail;
  final String description;
  final String downloadlink;
  final String source;
  final String type;
  final String youtubeid;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.red.shade300, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Provider.of<MovieProvider>(context, listen: false)
                    .deletMovie(widget.movieid, widget.title, widget.type);
                Navigator.of(context).pop();

                // Add your delete
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectedMenuOption(BuildContext context, String option) {
    print(option);
    switch (option) {
      case 'delete':
        _showAlertDialog(context, 'Delete Movie',
            'Are you sure you want to delete  ${widget.title}');
// Perform delete action
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => UploadMovie(
              imageUrl: widget.imgUrl,
              type: widget.type,
              title: widget.title,
              rating: widget.rating,
              description: widget.description,
              detail: widget.detail,
              downloadlink: widget.downloadlink,
              source: widget.source,
              youtubelink: widget.youtubeid,
            ),
          ),
        );
// Perform edit action
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rating: ${widget.rating}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
          ),
          Consumer<ProfileManager>(builder: (context, profileProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.source),
                profileProvider.isAdmin
                    ? PopupMenuButton<String>(
                        icon: const RotatedBox(
                            quarterTurns: 1, child: Icon(Icons.more_horiz)),
                        onSelected: (String result) {
                          _onSelectedMenuOption(context, result);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Delete movie',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              icon: Icon(Icons.delete,
                                  color: Colors.red.shade700),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Edit movie',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'trend',
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text(
                                'Make Trending',
                                style: TextStyle(color: Colors.yellow.shade700),
                              ),
                              icon: Icon(
                                Icons.star,
                                color: Colors.yellow.shade700,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
