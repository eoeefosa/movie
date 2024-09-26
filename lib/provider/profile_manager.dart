import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/styles/snack_bar.dart';

import '../api/api_calls/auth.dart';
import '../models/movie.dart';

class ProfileManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  User? get currentUser => _auth.currentUser;

  Future<void> addMovie(Movie movie) async {
    try {
      await _firestore.collection(movie.type).add({
        ...movie.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMovie(Movie movie) async {
    MovieApi api = MovieApi();
    try {
      await api.updateMovieById(movie.id, movie.type, {
        ...movie.toMap(),
        'edited timestamp': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String emailname, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: emailname, password: password);
      user = result.user;
      isLogin = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showsnackBar('No user linked with this email.');
      } else if (e.code == 'wrong-password') {
        showsnackBar('Wrong password provided.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // final bool _isAdmin = false;
  bool isLogin = false;
  String username = '';
  String email0 = '';
  String profileImageUrl =
      'https://th.bing.com/th/id/R.76c882edad7141df823d9a41b8c7820e?rik=NAn9mL%2fpwz%2fLNw&pid=ImgRaw&r=0';
  bool isloading = false;
  final authapi = Auth();

  final List<String> favoriteMovies = [
    // 'Inception',
    // 'The Dark Knight',
    // 'Interstellar',
    // 'Tenet'
  ];

  String get email => email0;
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  bool get isAdmin => user == null
      ? false
      : user!.email == 'eoeefosa@gmail.com' ||
          user!.email == 'Torihd247@gmail.com' ||
          user!.email == 'torihd247@gmail.com';

  void getdarkmode() {}

  void toggleDarkmode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  set darkMode(bool thisdarkMode) {
    _darkMode = thisdarkMode;
    notifyListeners();
  }

  void setdarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }
}
