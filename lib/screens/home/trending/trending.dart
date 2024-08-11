import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:torihd/ads/ad_controller.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/movieboxtheme.dart';
import 'package:torihd/screens/product/product.dart';

import '../../../ads/banner_ad_widget.dart';
import '../../../models/appState/profile_manager.dart';
import '../../../provider/movieprovider.dart';
import '../../upload/uploadmovie.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
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
          if (adsControllerAvailable) ...[
            const Expanded(
              child: Center(
                child: BannerAdWidget(),
              ),
            ),
          ],
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
                      topPicks.isEmpty ? 'Top Picks' : 'Top Picks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: topPicks.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 3 / 5),
                    itemBuilder: (context, index) {
                      final topPick = topPicks[index];

                      return TopPickCard(
                        title: topPick.title,
                        type: topPick.type,
                        imgUrl: topPick.movieImgurl,
                        rating: topPick.rating,
                        youtubeid: topPick.youtubetrailer,
                        movieid: topPick.id,
                        movie: topPick, // Using the document ID as the movie ID
                      );
                    },
                  ),
                ],
              );
            }
          })
        ],
      ),
    );
  }
}

//  "title": "DC League of Super-Pets",
//           "type": "United States Action",
//           "img": "assets/images/food_burger.jpg",
//           "rating": 7.1,

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
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints.expand(
        width: 300,
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

class TopPickCard extends StatefulWidget {
  const TopPickCard({
    super.key,
    required this.title,
    required this.type,
    required this.imgUrl,
    required this.rating,
    required this.youtubeid,
    required this.movieid,
    required this.movie,
  });

  final String title;
  final String type;
  final String youtubeid;
  final String imgUrl;
  final String rating;
  final String movieid;
  final Movie movie;

  @override
  State<TopPickCard> createState() => _TopPickCardState();
}

class _TopPickCardState extends State<TopPickCard> {
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
              description: widget.movie.description,
              detail: widget.movie.detail,
              downloadlink: widget.movie.downloadlink,
              source: widget.movie.source,
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width and height based on the screen width
    double cardWidth = screenWidth * 0.3;
    double cardHeight = cardWidth * 1.3;

    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Videoplayer(
                movieid: widget.movieid,
                type: widget.type,
                youtubeid: widget.youtubeid,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            constraints: BoxConstraints.expand(
              width: cardWidth,
              height: cardHeight,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: const ColorFilter.srgbToLinearGamma(),
                image: CachedNetworkImageProvider(widget.imgUrl),
                fit: BoxFit.cover,
              ),
              // backgroundBlendMode: BlendMode.darken,
              // color: Colors.black.withOpacity(),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Consumer<ProfileManager>(
                    builder: (context, profileProvider, child) {
                  return profileProvider.isAdmin
                      ? Positioned(
                          top: 4,
                          right: 0,
                          child: PopupMenuButton<String>(
                            // surfaceTintColor: Colors.yellow,
                            elevation: 2,
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
                                    style:
                                        TextStyle(color: Colors.red.shade700),
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
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
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
                                    style: TextStyle(
                                        color: Colors.yellow.shade700),
                                  ),
                                  icon: Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ))
                      : Container();
                }),
                const Positioned(
                  bottom: 4,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.0, right: 2.0),
                    child: Icon(
                      Icons.download,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: Text(
                    widget.rating,
                    style: MovieBoxTheme.darkTextTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: Text(
            widget.type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
