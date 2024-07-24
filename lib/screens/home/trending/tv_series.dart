import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/home/trending/trending.dart';

import '../../../api/mockapiservice.dart';

class TVSeries extends StatelessWidget {
   TVSeries({super.key});
  final mockService = MovieBoxCloneApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getTrending(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List trendingCarosel = snapshot.data[0] ?? [];
          final List trendingContent = snapshot.data[1] ?? [];

          return GridView.builder(
            shrinkWrap: true,
            itemCount: 18,
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
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
