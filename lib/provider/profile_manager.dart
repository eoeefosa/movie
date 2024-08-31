import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torihd/api/movie_api.dart';

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

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      notifyListeners();
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
  final bool _isLogin = false;
  final String _username = '';
  final String _email = '';
  final String _profileImageUrl =
      'https://th.bing.com/th/id/R.76c882edad7141df823d9a41b8c7820e?rik=NAn9mL%2fpwz%2fLNw&pid=ImgRaw&r=0';
  bool isloading = false;
  final authapi = Auth();

  final List<String> _favoriteMovies = [
    // 'Inception',
    // 'The Dark Knight',
    // 'Interstellar',
    // 'Tenet'
  ];

  String get username => _username;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;
  List<String> get favoriteMovies => _favoriteMovies;
  bool get didSelectUser => _didSelectUser;
  bool get darkMode => _darkMode;
  bool get isAdmin => user == null
      ? false
      : user!.email == 'eoeefosa@gmail.com' ||
          user!.email == 'Torihd247@gmail.com' ||
          user!.email == 'torihd247@gmail.com';

  bool get isLogin => _isLogin;

  bool _darkMode = false;
  final bool _didSelectUser = false;

  void getdarkmode() {
    
  }

  void toggleDarkmode() {
    _darkMode = !darkMode;
    notifyListeners();
  }

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  void setdarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}
