import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import the Shimmer package
import 'package:torihd/provider/movieprovider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:torihd/screens/moviescreen/viewmovies.dart';

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
  State<MovieswithProvider> createState() => _MovieswithProviderState();
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
    Provider.of<MovieProvider>(context, listen: false).fetchmovie();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.movieisloading) {
        // Show shimmer effect when loading
        return _buildShimmerGrid(); // Use shimmer grid
      } else if (movieProvider.movies.isEmpty) {
        return Center(
          child: Text(
            "No Movies available",
            style: TextStyle(fontSize: 16.sp),
          ),
        );
      } else {
        final List<Movie> movies = movieProvider.movies;
        return RefreshIndicator(
          onRefresh: _refreshTrendingData,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final Movie movie = movies[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Viewmovies(
                        movieid: movie.id!,
                        type: movie.type,
                        youtubeid: movie.youtubetrailer,
                      ),
                    ),
                  ),
                  child: MovieCard(
                    movie: movie,
                    title: movie.title,
                    type: movie.type,
                    imgUrl: movie.movieImgurl,
                    rating: movie.rating,
                    youtubeid: movie.youtubetrailer,
                    movieid: movie.id!,
                    description: movie.description,
                    detail: movie.detail,
                    source: movie.source,
                  ),
                );
              },
              staggeredTileBuilder: (int index) {
                // Make the tile span the full width for one of the tiles
                return const StaggeredTile.fit(1);
              },
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
            ),
          ),
        );
      }
    });
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: 6, // Number of shimmer items to display
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.r), // Responsive border radius
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.h, // Responsive height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.r)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.w), // Responsive padding
                  child: Container(
                    height: 14.h, // Responsive height
                    width: 100.w, // Responsive width
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w), // Responsive padding
                  child: Container(
                    height: 11.h, // Responsive height
                    width: 60.w, // Responsive width
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.h), // Responsive spacing
              ],
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
        mainAxisSpacing: 8.h, // Responsive spacing
        crossAxisSpacing: 8.w, // Responsive spacing
      ),
    );
  }
}
