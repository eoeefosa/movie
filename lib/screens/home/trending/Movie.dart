import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/profile_manager.dart';
// import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/moviescreen/moviescreen.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:torihd/screens/upload/uploadmovie.dart';


import '../../../models/movie.dart';
import '../widgets/moviecard.dart';

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
            staggeredTileBuilder: (int index) {
              // Make the tile at the 3rd position span both columns
              // if (index == 2) {
              //   return const StaggeredTile.fit(2); // Full width
              // } else {
              return const StaggeredTile.fit(1); // Half width
              // }
            },
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        );
      }
    });
  }
}
