import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:torihd/models/movie.dart';
import 'package:torihd/movieboxtheme.dart';
import 'package:torihd/screens/product/product.dart';

import '../../../provider/movieprovider.dart';

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
      Provider.of<MovieProvider>(context, listen: false).fetchTopPick();
    });
  }

  // Future<List<dynamic>> fetchTrendingData() async {
  //   final firestore = FirebaseFirestore.instance;

  //   // Fetch Trending Carousel data
  //   final carouselSnapshot =
  //       await firestore.collection('Trending Carousel').get();
  //   final trendingCarosel =
  //       carouselSnapshot.docs.map((doc) => doc.data()).toList();

  //   // Fetch Top Picks data
  //   final topPicksSnapshot = await firestore.collection('Top Picks').get();
  //   final trendingContent =
  //       topPicksSnapshot.docs.map((doc) => doc.data()).toList();
  //   final trendingid = topPicksSnapshot.docs.map((doc) => doc.id).toList();

  //   return [trendingCarosel, trendingContent, trendingid];
  // }

  Future<void> _refreshTrendingData() async {
    setState(() {
      // _trendingData = fetchTrendingData();
      Provider.of<MovieProvider>(context, listen: false)
          .fetchTrendingCarousel();
      Provider.of<MovieProvider>(context, listen: false).fetchTopPick();
    });
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
            if (movieProvider.trendingCarouselloading) {
              return const Center(child: CircularProgressIndicator());
            } else if (movieProvider.trendingCarousel.isEmpty) {
              return const Center(
                child: Text("No Movies available"),
              );
            } else {
              List<Movie> trendingcarousellist = movieProvider.trendingCarousel;
              return CarouselSlider(
                items: trendingcarousellist
                    .map((item) => CaroselCard(
                        title: item.title,
                        imgUrl: item.movieImgurl,
                        ads: false))
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
              return const Center(child: CircularProgressIndicator());
            } else if (movieProvider.toppick.isEmpty) {
              return const Center(
                child: Text("No Movies available"),
              );
            } else {
              List<Movie> topPicks = movieProvider.toppick;
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
                        movieid:
                            topPick.id, // Using the document ID as the movie ID
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
          colorFilter: const ColorFilter.srgbToLinearGamma(),
          image:
              NetworkImage(imgUrl), // Changed to NetworkImage to fetch from URL
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
            style: Theme.of(context).textTheme.bodyLarge,
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
                          style: Theme.of(context).textTheme.bodySmall,
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

class TopPickCard extends StatelessWidget {
  const TopPickCard({
    super.key,
    required this.title,
    required this.type,
    required this.imgUrl,
    required this.rating,
    required this.youtubeid,
    required this.movieid,
  });

  final String title;
  final String type;
  final String youtubeid;
  final String imgUrl;
  final String rating;
  final String movieid;

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
                movieid: movieid,
                type: type,
                youtubeid: youtubeid,
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
                image: AssetImage(imgUrl),
                fit: BoxFit.cover,
              ),
              backgroundBlendMode: BlendMode.darken,
              color: Colors.black45,
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
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
                    rating,
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
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: Text(
            type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
