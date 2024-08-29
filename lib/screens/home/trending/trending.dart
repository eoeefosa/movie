import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:torihd/ads/ad_controller.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/movieboxtheme.dart';
import 'package:torihd/screens/home/trending/Movie.dart';
import 'package:torihd/screens/home/widgets/autoslidinggrid.dart';
import 'package:torihd/screens/moviescreen/moviescreen.dart';

import '../../../ads/banner_ad_widget.dart';
import '../../../provider/profile_manager.dart';
import '../../../provider/movieprovider.dart';
import '../../upload/uploadmovie.dart';
import '../widgets/moviecard.dart';
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
    // Fetch movies after the first frame
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
    Provider.of<MovieProvider>(context, listen: false).fetchTrendingCarousel();
    final adsController = context.read<AdsController?>();
    adsController?.preloadAd();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshTrendingData,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(
            height: 20,
          ),
          Consumer<MovieProvider>(builder: (context, movieProvider, child) {
            if (movieProvider.movieisloading || movieProvider.tvseriesloading) {
              return const Center(child: CircularProgressIndicator());
              // } else if (movieProvider.trendingCarousel.isEmpty) {
              //   return const Center(
              //     child: Text("No Movies available"),
              //   );
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
            if (movieProvider.topPickloading) {
              return Center(
                child: Container(),
              );
            } else if (movieProvider.movies.isEmpty &&
                movieProvider.tvSeries.isEmpty) {
              return Center(
                child: Container(),
              );
            } else {
              List<Movie> topPicks = movieProvider.trendingCarousel +
                  movieProvider.movies +
                  movieProvider.tvSeries;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      topPicks.isEmpty ? 'Trending' : 'Trending',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                      height: 300,
                      child: AutoSlidingGridView(
                        movieProvider: movieProvider,
                      )),
                  SizedBox(
                    height: 100,
                    child: _buildAdvertsWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      topPicks.isEmpty ? 'Top Picks' : 'Top Picks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 6,
                    axisDirection: AxisDirection.down,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      ...List.generate(
                        topPicks.length + (topPicks.length / 3).floor(),
                        (index) {
                          if (index != 0 && index % 4 == 3) {
                            // Insert an ad after every 3rd topPick
                            return StaggeredGridTile.count(
                              crossAxisCellCount: 6,
                              mainAxisCellCount: 1,
                              child: _buildAdvertsWidget(),
                            );
                          } else {
                            // Calculate the actual topPick index, accounting for the ads
                            int topPickIndex = index - (index / 4).floor();

                            final topPick = topPicks[topPickIndex];

                            return StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 3,
                              child: TopPickCard(
                                title: topPick.title,
                                type: topPick.type,
                                imgUrl: topPick.movieImgurl,
                                rating: topPick.rating,
                                youtubeid: topPick.youtubetrailer,
                                movieid: topPick.id,
                                movie:
                                    topPick, // Using the document ID as the movie ID
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  _buildAdvertsWidget() {
    final adsControllerAvailable = context.watch<AdsController?>() != null;

    if (adsControllerAvailable) {
      return const Expanded(
        child: Center(
          child: BannerAdWidget(),
        ),
      );
    }
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
          // colorFilter: const ColorFilter.srgbToLinearGamma(),
          image: CachedNetworkImageProvider(
              imgUrl), // Changed to NetworkImage to fetch from URL
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
          !ads
              ? Positioned(
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
                )
              : Container()
        ],
      ),
    );
  }
}
