import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:torihd/ads/ad_controller.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/screens/home/widgets/autoslidinggrid.dart';
import 'package:torihd/screens/moviescreen/moviescreen.dart';

import '../../../ads/banner_ad_widget.dart';
import '../../../provider/movieprovider.dart';
import '../widgets/toppicks.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchmovie();
      Provider.of<MovieProvider>(context, listen: false).fetchTvSeries();
      Provider.of<MovieProvider>(context, listen: false)
          .fetchTrendingCarousel();
    });

    final adsController = context.read<AdsController?>();
    adsController?.preloadAd();
  }

  Future<void> _refreshTrendingData() async {
    Provider.of<MovieProvider>(context, listen: false).fetchmovie();
    Provider.of<MovieProvider>(context, listen: false).fetchTvSeries();
    Provider.of<MovieProvider>(context, listen: false).fetchTrendingCarousel();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshTrendingData,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 20),
          Consumer<MovieProvider>(builder: (context, movieProvider, child) {
            if (movieProvider.movieisloading || movieProvider.tvseriesloading) {
              return _buildShimmerCarousel();
            } else {
              List<Movie> trendingcarousellist =
                  movieProvider.trendingCarousel +
                      movieProvider.movies +
                      movieProvider.tvSeries;
              return CarouselSlider(
                items: trendingcarousellist
                    .map((item) => InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Videoplayer(
                                movieid: item.id,
                                type: item.type,
                                youtubeid: item.youtubetrailer,
                              ),
                            ),
                          ),
                          child: CaroselCard(
                              title: item.title,
                              imgUrl: item.movieImgurl,
                              ads: false),
                        ))
                    .toList(),
                options: CarouselOptions(
                  aspectRatio: 16 / 6,
                  viewportFraction: 0.85,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.1,
                  scrollDirection: Axis.horizontal,
                ),
              );
            }
          }),
          Consumer<MovieProvider>(builder: (context, movieProvider, child) {
            if (movieProvider.topPickloading || movieProvider.movieisloading) {
              return _buildShimmerGrid(); // Show shimmer grid when loading
            } else if (movieProvider.movies.isEmpty &&
                movieProvider.tvSeries.isEmpty) {
              return const Center(
                child: Text("No movies available"),
              );
            } else {
              List<Movie> topPicks = movieProvider.movies;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  _buildAdvertsWidget(), // Insert Ad Widget here

                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0.w, vertical: 4.0.h),
                    child: Text(
                      'Trending',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AutoSlidingGridView(
                    movieProvider: movieProvider,
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: _buildAdvertsWidget(),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0.w, vertical: 4.0.h),
                    child: Text(
                      'Top Picks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  MasonryGridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.w,
                    mainAxisSpacing: 5.h,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topPicks.length + (topPicks.length / 3).floor(),
                    itemBuilder: (context, index) {
                      if (index != 0 && index % 4 == 3) {
                        // Insert an ad after every 3rd topPick
                        return _buildFullWidthAdWidget(context);
                      } else {
                        int topPickIndex = index - (index / 4).floor();

                        final topPick = topPicks[topPickIndex];

                        return TopPickCard(
                          title: topPick.title,
                          type: topPick.type,
                          imgUrl: topPick.movieImgurl,
                          rating: topPick.rating,
                          youtubeid: topPick.youtubetrailer,
                          movieid: topPick.id,
                          movie: topPick,
                        );
                      }
                    },
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildFullWidthAdWidget(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;

    if (adsControllerAvailable) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200.h, // Full width of the screen
        child: const BannerAdWidget(),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: Text(
            "Tori HD: The best movie streaming app!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

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

  // Shimmer effect for carousel slider
  Widget _buildShimmerCarousel() {
    return CarouselSlider(
      items: List.generate(
        5,
        (index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        aspectRatio: 16 / 6,
        viewportFraction: 0.85,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.1,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  // Shimmer effect for grid items
  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
        itemCount: 6,
      ),
    );
  }
}

class CaroselCard extends StatelessWidget {
  const CaroselCard({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.ads,
  });

  final String title;
  final String imgUrl;
  final bool ads;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: BoxConstraints.expand(
        width: size.width * .85,
        height: 100,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(imgUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Stack(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey.shade100),
          ),
          if (!ads)
            Positioned(
              bottom: 4,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0, right: 2.0),
                      child: Icon(
                        Icons.download,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Free Download",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey.shade100),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
