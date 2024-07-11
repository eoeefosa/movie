import 'package:flutter/material.dart' ;

import '../../../api/mockapiservice.dart';

class Movie extends StatelessWidget {
  Movie({super.key});
  final mockService = MovieBoxCloneApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mockService.getTrending(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List trendingCarosel = snapshot.data[0] ?? [];
            final List trendingContent = snapshot.data[1] ?? [];

            return ListView(scrollDirection: Axis.vertical, children: const []);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [],
    );
  }
}
