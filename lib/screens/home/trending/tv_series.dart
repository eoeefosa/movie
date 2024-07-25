import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/home/trending/trending.dart';

import '../../../api/mockapiservice.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TVSeries extends StatelessWidget {
  TVSeries({super.key});
  final mockService = MovieBoxCloneApi();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('TV Series').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No movies found'));
        }

        final movies = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          itemCount: movies.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3 / 5),
          itemBuilder: (context, index) {
            final movieDoc = movies[index];
            final movie = movieDoc.data() as Map<String, dynamic>;
            final movieId = movieDoc.id;

            return TopPickCard(
              title: movie["title"] ?? 'Untitled',
              type: movie["type"],
              imgUrl: movie["movieImgUrl"] ?? 'assets/images/ypf.png',
              rating: movie['rating'] ?? 7.5,
              youtubeid: movie["youtubetrailer"],
              movieid: movieId,  // Using the document ID as the movie ID
            );
          },
        );
      },
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
  final String imgUrl;
  final double rating;
  final String youtubeid;
  final String movieid;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imgUrl),  // Changed to Image.asset for consistency
          Text(title),
          Text(type),
          Text('Rating: $rating'),
        ],
      ),
    );
  }
}
