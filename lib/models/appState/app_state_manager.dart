import 'package:flutter/material.dart';
import 'package:torihd/models/appState/app_cache.dart';

class MovieboxTab {
  static const int home = 0;
  static const int shorttv = 1;
  static const int downloads = 2;
  static const int me = 3;
}

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedIn = false;
  bool _onboardingComplete = false;
  int _selectedTab = MovieboxTab.home;
  final _appCache = AppCache();

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  Future<bool> initializeApp() async {
    _loggedIn = await _appCache.isUserLoggedIn();
    _onboardingComplete = await _appCache.didCompleteOnboarding();
    // TODO: CHECK FOR USER NAME AND TOKEN
    _initialized = true;
    return _initialized;
  }

  // use future and set data to make api request and login user
  void login(String username, String password) async {
    _loggedIn = true;
    await _appCache.cacheUser();
    notifyListeners();
  }

  void onboarded() async {
    _onboardingComplete = true;
    await _appCache.completeOnboarding();
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  // TODO:I did not thing go to shotTv would be important

  // Signs Oute the current user
  Future<void> logout() async {
    _initialized = false;
    _selectedTab = 0;
    await _appCache.invalidate();
    initializeApp();
    notifyListeners();
  }
}
