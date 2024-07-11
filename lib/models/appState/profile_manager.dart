import 'package:flutter/material.dart';

class ProfileManager extends ChangeNotifier {
  final String _username = 'John Doe';
  final String _email = 'john.doe@example.com';
  final String _profileImageUrl =
      'https://th.bing.com/th/id/R.76c882edad7141df823d9a41b8c7820e?rik=NAn9mL%2fpwz%2fLNw&pid=ImgRaw&r=0';
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

  bool _darkMode = true;
  bool _didSelectUser = false;

  void toggleDarkmode() {
    _darkMode = !darkMode;
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
