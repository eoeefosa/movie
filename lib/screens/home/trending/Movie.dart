import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
// import 'package:torihd/models/movie.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/screens/product/product.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

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
        return StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

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
              ),
            );
          },
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        );
      }
    });
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.rating,
    required this.movieid,
    required this.type,
    required this.youtubeid,
  });

  final String title;
  final String imgUrl;
  final String rating;
  final String movieid;
  final String type;
  final String youtubeid;

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
              imageUrl: imgUrl,
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
              title,
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
                  "Rating: $rating",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement trailer viewing functionality
              },
              child: const Text('Download'),
            ),
          ),
        ],
      ),
    );

    // return InkWell(
    //   onTap: () => Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) => Videoplayer(
    //         movieid: movieid,
    //         type: type,
    //         youtubeid: youtubeid,
    //       ),
    //     ),
    //   ),
    //   child: Card(
    //     elevation: 4,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         ClipRRect(
    //           borderRadius:
    //               const BorderRadius.vertical(top: Radius.circular(8)),
    //           child: Image.network(
    //             imgUrl,
    //             fit: BoxFit.cover,
    //             width: double.infinity,
    //             height: 150,
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 title,
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //               const SizedBox(height: 4),
    //               Row(
    //                 children: [
    //                   Icon(Icons.star, color: Colors.yellow[700]),
    //                   const SizedBox(width: 4),
    //                   Text(
    //                     rating.toString(),
    //                     style: Theme.of(context).textTheme.bodyMedium,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
