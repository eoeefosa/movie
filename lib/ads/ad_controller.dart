import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'preloaded_banner_ads.dart';

class AdsController {
  final MobileAds _instance;
  PreloadedBannerAd? _preloadedBannerAd;

  AdsController({required MobileAds instance}) : _instance = instance;

  /// Dispose of any resources held by this controller.
  void dispose() {
    _preloadedBannerAd?.dispose();
    _preloadedBannerAd = null; // Clear the reference after disposing
  }

  /// Initializes the Mobile Ads SDK.
  Future<void> initialize() async {
    try {
      await _instance.initialize();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to initialize Mobile Ads SDK: $e");
      }
    }
  }

  /// Preloads a banner ad to be displayed later.
  void preloadAd() {
    final adUnitId = defaultTargetPlatform == TargetPlatform.android
        ? 'ca-app-pub-1107087522848284/1294711540'
        : ''; // Add ad unit id for iOS if needed

    _preloadedBannerAd =
        PreloadedBannerAd(size: AdSize.fullBanner, adUnitId: adUnitId);

    // Load the ad and handle potential errors
    _preloadedBannerAd?.load().then((_) {
      if (kDebugMode) {
        print("Ad preloaded successfully.");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to preload ad: $error");
      }
      // Optionally, you could handle retry logic here
      _preloadedBannerAd = null; // Clear the failed ad instance
    });
  }

  /// Takes the preloaded ad and returns it, or returns null if no ad is preloaded.
  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedBannerAd;
    _preloadedBannerAd =
        null; // Clear the reference to ensure the ad is only used once
    return ad;
  }
}
