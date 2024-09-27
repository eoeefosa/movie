import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/styles/snack_bar.dart';

import '../api/api_calls/auth.dart';
import '../models/movie.dart';

enum ThemeModeType { light, dark, system }

class ProfileManager extends ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.system;

  ThemeModeType get themeMode => _themeMode;

  void setThemeMode(ThemeModeType mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleDarkmode() {
    if (_themeMode == ThemeModeType.light) {
      _themeMode = ThemeModeType.dark;
    } else {
      _themeMode = ThemeModeType.light;
    }
    notifyListeners();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get currentUser => _user;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if the user is not null and assign to _user
      _user = result.user;
      print("Sign-in successful: ${_user?.email}"); // Debug log
      isLogin = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showsnackBar('No user linked with this email.');
      } else if (e.code == 'wrong-password') {
        showsnackBar('Wrong password provided.');
      } else {
        showsnackBar('Error: ${e.message}');
      }
    } catch (e) {
      print("Unexpected error: $e"); // Improved error logging
      rethrow;
    }
  }

  // Sign Up method
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = result.user; // Assign user to the private variable
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("Error signing up: $e");
      rethrow;
    }
  }

  // Fetch current user
  Future<void> getUser() async {
    try {
      _user = _auth.currentUser; // Get the current user
      notifyListeners(); // Notify listeners about the state change
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

  // Sign Out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null; // Clear user variable
      notifyListeners();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }

  // Reset Password method
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }

  // Handle Firebase authentication errors
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        print('The email address is not valid.');
        break;
      case 'user-disabled':
        print('The user corresponding to the given email has been disabled.');
        break;
      case 'user-not-found':
        print('No user corresponding to the given email.');
        break;
      case 'wrong-password':
        print('The password is invalid for the given email.');
        break;
      default:
        print('An undefined Error happened. ${e.message}');
    }
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

  bool get isAdmin => _user == null
      ? false
      : _user!.email == 'rty@gmail.com' ||
          _user!.email == 'Torihd247@gmail.com' ||
          _user!.email == 'torihd247@gmail.com';
}
