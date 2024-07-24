import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieboxclone/models/other/movie_model.dart';

class MovieController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMovie(
    String title,
    String description,
  ) async {
    try {
      await _firestore.collection('movies').add({
        "title": title,
        "description": description,
        'timestamp': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MovieModel>> getMovies() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('movies').get();
      return snapshot.docs
          .map((doc) =>
              MovieModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> fetchMovies() {
    return _firestore
        .collection('movies')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
