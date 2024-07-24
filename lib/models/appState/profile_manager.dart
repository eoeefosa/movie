import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api/api_calls/auth.dart';
import '../usermodel.dart';

class ProfileManager extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  final bool _isAdmin = true;
  final bool _isLogin = false;
  final String _username = '';
  final String _email = '';
  final String _profileImageUrl =
      'https://th.bing.com/th/id/R.76c882edad7141df823d9a41b8c7820e?rik=NAn9mL%2fpwz%2fLNw&pid=ImgRaw&r=0';
  bool isloading = false;
  final authapi = Auth();

  // void signIn(String email, String password) async {
  //   isloading = true;
  //   final Usermodel? result = await authapi.signUpuser(email, password);
  //   if (result != null) {
  //     _username = result.username ?? '';
  //     _email = result.email ?? '';
  //     _profileImageUrl = result.profileImageUrl ?? '';
  //   }
  //   isloading = false;
  //   notifyListeners();
  // }

  // void signUp(String email, String password) async {
  //   isloading = true;
  // }

  final List<String> _favoriteMovies = [
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Tenet'
  ];

  String get username => _username;
  String get email => _email;
  String get profileImageUrl => _profileImageUrl;
  List<String> get favoriteMovies => _favoriteMovies;
  bool get didSelectUser => _didSelectUser;
  bool get darkMode => _darkMode;
  bool get isAdmin => _isAdmin;
  bool get isLogin => _isLogin;

  bool _darkMode = true;
  bool _didSelectUser = false;

  void toggleDarkmode() {
    _darkMode = !darkMode;
    notifyListeners();
  }

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;
    notifyListeners();
  }

  void setdarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}
