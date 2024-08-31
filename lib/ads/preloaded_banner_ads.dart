import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

class PreloadedBannerAd {
  static final _log = Logger("PreloadedBannerAd");

  /// Ad size like [AdSize.mediumRectangle].
  final AdSize size;
  final AdRequest _adRequest;
  BannerAd? _bannerAd;
  final String adUnitId;
  final _adCompleter = Completer<BannerAd>();

  PreloadedBannerAd({
    required this.size,
    AdRequest? adRequest,
    required this.adUnitId,
  }) : _adRequest = adRequest ?? const AdRequest();

  Future<BannerAd> get ready => _adCompleter.future;

  Future<void> load() async {
    try {
      _bannerAd = BannerAd(
        size: size,
        adUnitId: adUnitId,
        request: _adRequest,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _log.info(() => 'Ad loaded successfully: ${ad.adUnitId}');
            if (!_adCompleter.isCompleted) {
              _adCompleter.complete(ad as BannerAd);
            }
          },
          onAdFailedToLoad: (ad, error) {
            _log.warning('Ad failed to load: $error');
            if (!_adCompleter.isCompleted) {
              _adCompleter.completeError(error);
            }
            ad.dispose();
          },
          onAdImpression: (ad) {
            _log.info('Ad impression registered.');
          },
          onAdClicked: (ad) {
            _log.info('Ad click registered.');
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e, stackTrace) {
      _log.severe('Error occurred while loading ad: $e', e, stackTrace);
      if (!_adCompleter.isCompleted) {
        _adCompleter.completeError(e);
      }
    }
  }

  void dispose() {
    _log.info('Disposing preloaded banner ad.');
    _bannerAd?.dispose();
    _bannerAd = null; // Clear reference after disposing
  }
}
