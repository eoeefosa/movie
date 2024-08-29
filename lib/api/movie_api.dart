import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:torihd/models/movie.dart';

class MovieApi {
  final firestore = FirebaseFirestore.instance;
  Future<Movie?> fetchavideo(String type, String id) async {
    try {
      final result =
          await FirebaseFirestore.instance.collection(type).doc(id).get();

      if (result.exists && result.data() != null) {
        // Convert the fetched data to a Movie instance
        return Movie.fromMap(result.data() as Map<String, dynamic>);
      } else {
        debugPrint('No movie found with the given ID.');
        return null;
      }
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

  Future<List<Movie>> fetchmovies() async {
    try {
      final movies = await firestore.collection('Movie').get();
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
      print(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Movie>> fetchTvseries() async {
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

  Future<List<Movie>> fetchTrendingCarousel() async {
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

  Future<List<Movie>> topPick() async {
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

  // Update a movie by ID
  Future<void> updateMovieById(
      String id, String type, Map<String, dynamic> updatedData) async {
    try {
      await firestore.collection('Movie').doc(id).update(updatedData);
      debugPrint('Movie updated successfully');
    } on FirebaseException catch (e) {
      debugPrint('Failed to update movie: $e');
      throw Exception('Failed to update movie: ${e.message}');
    }
  }

  // Delete a movie by ID
  Future<void> deleteMovieById(String id, String type) async {
    try {
      await firestore.collection(type).doc(id).delete();
      debugPrint('Movie deleted successfully');
    } on FirebaseException catch (e) {
      debugPrint('Failed to delete movie: $e');
      throw Exception('Failed to delete movie: ${e.message}');
    }
  }
}
