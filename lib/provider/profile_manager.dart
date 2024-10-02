import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torihd/api/movie_api.dart';
import 'package:torihd/cache/local_setting_persistence.dart';
import 'package:torihd/styles/snack_bar.dart';

import '../api/api_calls/auth.dart';
import '../models/movie.dart';

enum ThemeModeType { light, dark, system }

class ProfileManager extends ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.system;
  LocalSettingPersistence localSettingPersistence = LocalSettingPersistence();

  ProfileManager() {
    init();
  }

  Future<void> init() async {
    checkIfLoggedIn();
    _themeMode = await localSettingPersistence.gettheme();
    // Initialize user
    final token = await localSettingPersistence.gettoken();
    if (token != null) {
      await _getUserFromToken(token);
    }
    notifyListeners();
  }

  ThemeModeType get themeMode => _themeMode;

  void setThemeMode(ThemeModeType mode) {
    _themeMode = mode;
    localSettingPersistence.settheme(mode);
    notifyListeners();
  }

  void toggleDarkmode() {
    if (_themeMode == ThemeModeType.light) {
      _themeMode = ThemeModeType.dark;
      localSettingPersistence.settheme(themeMode);
    } else if (_themeMode == ThemeModeType.dark) {
      _themeMode = ThemeModeType.system;
      localSettingPersistence.settheme(themeMode);
    } else {
      _themeMode = ThemeModeType.light;
      localSettingPersistence.settheme(themeMode);
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
      await api.updateMovieById(movie.id!, movie.type, {
        ...movie.toMap(),
        'edited timestamp': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get currentUser => _user;

  Future<void> _getUserFromToken(String token) async {
    try {
      // // Use FirebaseAuth to get the user from the token
      // final userCredential =
      //     await FirebaseAuth.instance.signInWithCustomToken(token);
      // _user = userCredential.user;
    } catch (e) {
      _user = null; // Clear user on failure
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if the user is not null and assign to _user
      _user = result.user;

      // Save the user's token
      String? token = await _user!.getIdToken(); // Get the user's ID token
      if (token != null) {
        // Store token in SharedPreferences with an expiration of 24 hours
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token);
        await prefs.setString('token_timestamp',
            DateTime.now().toIso8601String()); // Store timestamp of login
      }

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
      rethrow;
    }
  }

  Future<void> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    String? tokenTimestamp = prefs.getString('token_timestamp');

    if (token != null && tokenTimestamp != null) {
      DateTime loginTime = DateTime.parse(tokenTimestamp);
      Duration timeSinceLogin = DateTime.now().difference(loginTime);

      // Check if token is still valid (within 24 hours)
      if (timeSinceLogin.inHours < 24) {
        // Token is valid, the user remains signed in
        User? user = FirebaseAuth.instance.currentUser;
        _user = user;
        if (user != null) {
          isLogin = true;
        }
      } else {
        // Token has expired, log out the user
        await signOut();
      }
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
      rethrow;
    }
  }

  // Fetch current user
  Future<void> getUser() async {
    try {
      _user = _auth.currentUser; // Get the current user
      notifyListeners(); // Notify listeners about the state change
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null; // Clear user variable
      isLogin = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Reset Password method
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      rethrow;
    }
  }

  // Handle Firebase authentication errors
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        break;
      case 'user-disabled':
        break;
      case 'user-not-found':
        break;
      case 'wrong-password':
        break;
      default:
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
