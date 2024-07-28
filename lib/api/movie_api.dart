import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MovieApi {
  final firestore = FirebaseFirestore.instance;

  Future fetchmovies() async {
    firestore.collection('movies').get();
  }

  Future fetchTvseries() async {

    try{

    }on DioException catch (e, trace) {
      debugPrint(e.response?.data.runtimeType.toString());
      debugPrint(trace.toString());
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e, trace) {
      debugPrint(e.toString());
      debugPrint(trace.toString());
      throw Exception('An unexpected error occurred: $e');
    }
    FirebaseFirestore.instance.collection('TV Series');
  }

  Future<List<dynamic>> fetchTrendingData() async {
    try {
      // Fetch Trending Carousel data
      final carouselSnapshot =
          await firestore.collection('Trending Carousel').get();
      final trendingCarousel =
          carouselSnapshot.docs.map((doc) => doc.data()).toList();

      // Fetch Top Picks data
      final topPicksSnapshot = await firestore.collection('Top Picks').get();
      final trendingContent =
          topPicksSnapshot.docs.map((doc) => doc.data()).toList();
      final trendingId = topPicksSnapshot.docs.map((doc) => doc.id).toList();

      return [trendingCarousel, trendingContent, trendingId];
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
}
