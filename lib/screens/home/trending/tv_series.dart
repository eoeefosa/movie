import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/screens/home/trending/trending.dart';

import '../../../api/mockapiservice.dart';
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
  final mockService = MovieBoxCloneApi();
  @override
  void initState() {
    super.initState();
    // Fetch movies after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchTvSeries();
    });
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
        return GridView.builder(
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
              movieid: tvserie.id, // Using the document ID as the movie ID
            );
          },
        );
      }
    });
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
  final String imgUrl;
  final String rating;
  final String youtubeid;
  final String movieid;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imgUrl), // Changed to Image.asset for consistency
          Text(title),
          Text(type),
          Text('Rating: $rating'),
        ],
      ),
    );
  }
}
