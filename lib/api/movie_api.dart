import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';

class MovieApi {
  final firestore = FirebaseFirestore.instance;

  Future<List<Movie>> fetchmovies() async {
    try {
      final movies = await firestore.collection('movies').get();
      final moviesdat = movies.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final List<Movie> movieslist = moviesdat.map((movie) {
        return Movie.fromMap(movie);
      }).toList();

      return movieslist;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(
        'FirebaseException: ${e.message}',
      );
      debugPrint(trace.toString());
      throw Exception('FirebaseException: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future fetchTvseries() async {
    try {
      final movies = await firestore.collection('TV Series').get();
      final moviesdt = movies.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      final List<Movie> movieslist = moviesdt.map((movie) {
        return Movie.fromMap(movie);
      }).toList();

      return movieslist;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(
        'FirebaseException: ${e.message}',
      );
      debugPrint(trace.toString());
      throw Exception('FirebaseException: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List> fetchTrendingCarousel() async {
    try {
      final movies = await firestore.collection('Trending Carousel').get();
      final moviesdt = movies.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      final List<Movie> movieslist = moviesdt.map((movie) {
        return Movie.fromMap(movie);
      }).toList();

      return movieslist;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(
        'FirebaseException: ${e.message}',
      );
      debugPrint(trace.toString());
      throw Exception('FirebaseException: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      debugPrint(e.toString());
      final trace = StackTrace.current;

      debugPrint(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List> topPick() async {
    try {
      final movies = await firestore.collection('Top Picks').get();
      final moviesdat = movies.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final List<Movie> movieslist = moviesdat.map((movie) {
        return Movie.fromMap(movie);
      }).toList();

      return movieslist;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      final trace = StackTrace.current;
      debugPrint(
        'FirebaseException: ${e.message}',
      );
      debugPrint(trace.toString());
      throw Exception('FirebaseException: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      debugPrint(e.toString());
      final trace = StackTrace.current;

      debugPrint(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
  }

  
  // Future<List<dynamic>> fetchTrendingData() async {
  //   try {
  //     // Fetch Trending Carousel data
  //     final carouselSnapshot =
  //         await firestore.collection('Trending Carousel').get();
  //     final trendingCarousel =
  //         carouselSnapshot.docs.map((doc) => doc.data()).toList();

  //     // Fetch Top Picks data
  //     final topPicksSnapshot = await firestore.collection('Top Picks').get();
  //     final trendingContent =
  //         topPicksSnapshot.docs.map((doc) => doc.data()).toList();
  //     final trendingId = topPicksSnapshot.docs.map((doc) => doc.id).toList();
  //     final trendingContentresult = topPicksSnapshot.docs.map((doc) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       return data;
  //     }).toList();
  //     return [trendingCarousel, trendingContent, trendingId];
  //   } on FirebaseException catch (e) {
  //     debugPrint(e.toString());
  //     final trace = StackTrace.current;
  //     debugPrint(
  //       'FirebaseException: ${e.message}',
  //     );
  //     debugPrint(trace.toString());
  //     throw Exception('FirebaseException: ${e.message}');
  //   } catch (e) {
  //     // Handle any other exceptions
  //     debugPrint(e.toString());
  //     final trace = StackTrace.current;

  //     debugPrint(trace.toString());
  //     throw Exception('An unexpected error occurred: $e');
  //   }
  // }
}
