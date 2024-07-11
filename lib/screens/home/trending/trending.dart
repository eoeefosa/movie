import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieboxclone/api/mockapiservice.dart';
import 'package:movieboxclone/movieboxtheme.dart';

class Trending extends StatelessWidget {
  const Trending({super.key});

  @override
  Widget build(BuildContext context) {
    final mockService = MovieBoxCloneApi();
    return FutureBuilder(
      future: mockService.getTrending(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List trendingCarosel = snapshot.data[0] ?? [];
          final List trendingContent = snapshot.data[1] ?? [];

          return ListView(scrollDirection: Axis.vertical, children: [
            const SizedBox(
              height: 20,
            ),
            CarouselSlider(
              items: trendingCarosel
                  .map((item) => CaroselCard(
                      title: item["title"],
                      imgUrl: item["img_url"],
                      ads: item["ads"]))
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
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    trendingContent[0]["Category"],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 3 / 5),
                  itemBuilder: (context, index) {
                    final movies = trendingContent[0]["movies"][index];
                    return TopPickCard(
                      title: movies["title"],
                      type: movies["type"],
                      imgUrl: movies["img"],
                      rating: movies["rating"],
                    );
                  },
                ),
              ],
            )
          ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class CaroselCard extends StatelessWidget {
  const CaroselCard(
      {super.key,
      required this.title,
      required this.imgUrl,
      required this.ads});

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
          image: AssetImage(imgUrl),
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
            style: MovieBoxTheme.darkTextTheme.bodyLarge,
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
                          style: MovieBoxTheme.darkTextTheme.bodySmall,
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

//  "title": "DC League of Super-Pets",
//           "type": "United States Action",
//           "img": "assets/images/food_burger.jpg",
//           "rating": 7.1,

class TopPickCard extends StatelessWidget {
  const TopPickCard(
      {super.key,
      required this.title,
      required this.type,
      required this.imgUrl,
      required this.rating});

  final String title;
  final String type;
  final String imgUrl;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.go('/home/0/player'),
          child: Container(
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints.expand(
              width: 100,
              height: 150,
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
                    "$rating",
                    style: MovieBoxTheme.darkTextTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          type,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
