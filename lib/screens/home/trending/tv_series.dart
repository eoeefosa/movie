import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/home/trending/trending.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/movie.dart';
import '../../../provider/movieprovider.dart';

class TVSeries extends StatefulWidget {
  const TVSeries({super.key});

  @override
  State<TVSeries> createState() => _TVSeriesState();
}

class _TVSeriesState extends State<TVSeries> {
  @override
  void initState() {
    super.initState();
    // Fetch movies after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchTvSeries();
    });
  }

  Future<void> _refreshTrendingData() async {
    Provider.of<MovieProvider>(context, listen: false).fetchTrendingCarousel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      if (movieProvider.tvseriesloading) {
        return const Center(child: CircularProgressIndicator());
      } else if (movieProvider.tvSeries.isEmpty) {
        return const Center(
          child: Text("No TV Series available"),
        );
      } else {
        List<Movie> tvseries = movieProvider.tvSeries;
        return RefreshIndicator(
          onRefresh: _refreshTrendingData,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: tvseries.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 3 / 5),
            itemBuilder: (context, index) {
              final tvserie = tvseries[index];
              return TopPickCard(
                title: tvserie.title,
                type: tvserie.type,
                imgUrl: tvserie.movieImgurl,
                rating: tvserie.rating,
                youtubeid: tvserie.youtubetrailer,
                movieid: tvserie.id,
                movie: tvserie,
              );
            },
          ),
        );
      }
    });
  }
}
