import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'ad_controller.dart';
import 'preloaded_banner_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static final _log = Logger('BannerAdWidget');

  static const useAnchoredAdaptiveSize = false;
  BannerAd? _bannerAd;
  _LoadingState _adLoadinState = _LoadingState.initial;
  late Orientation _currentOrientation;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (_currentOrientation == orientation &&
          _bannerAd != null &&
          _adLoadinState == _LoadingState.loaded) {
        _log.info(() => 'We have everything we need. Showeing the ad '
            '${_bannerAd.hashCode} now');
        return SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      }
      // Reload the ad if the orientation changes.
      if (_currentOrientation != orientation) {
        _log.info('Orientation changed');
        _currentOrientation = orientation;
        _loadAd();
      }
      return const SizedBox();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
  }

  @override
  void dispose() {
    _log.info('disposing ad');
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final adsController = context.read<AdsController>();
    final ad = adsController.takePreloadedAd();
    if (ad != null) {
      _log.info('A preloaded banner was supplied. Using it.');
      _showPreloadeAd(ad);
    } else {
      _loadAd();
    }
  }

  /// Load (another) ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    if (!mounted) return;
    _log.info('_loadAd() called.');
    if (_adLoadinState == _LoadingState.loading ||
        _adLoadinState == _LoadingState.disposing) {
      _log.info('An ad is already being loaded or disposed. Aborting.');
      return;
    }
    _adLoadinState = _LoadingState.disposing;
    await _bannerAd?.dispose();
    _log.fine('_bannerAd dispose');
    if (!mounted) return;
    setState(() {
      _bannerAd = null;
      _adLoadinState = _LoadingState.loading;
    });

    AdSize size;

    if (useAnchoredAdaptiveSize) {
      final AnchoredAdaptiveBannerAdSize? adaptiveSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.truncate());
      if (adaptiveSize == null) {
        _log.warning('Unable to get height of anchored banner.');
        size = AdSize.banner;
      } else {
        size = adaptiveSize;
      }
    } else {
      size = AdSize.fullBanner;
    }
    if (!mounted) return;

    assert(Platform.isAndroid || Platform.isIOS,
        'AdMob currently does not support ${Platform.operatingSystem}');
    _bannerAd = BannerAd(
      size: size,
      adUnitId: Theme.of(context).platform == TargetPlatform.android
          ? 'ca-app-pub-8674216574091372/9505721553'
          : '',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _log.info(() => 'Ad loaded: ${ad.responseInfo}');
          setState(() {
            _bannerAd = ad as BannerAd;
            _adLoadinState = _LoadingState.loaded;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _log.warning('Banner failedToLoad: $error');
          ad.dispose();
        },
        onAdImpression: (ad) {
          _log.info('Ad impression registered');
        },
        onAdClicked: (ad) {
          _log.info('Ad click registerd');
        },
      ),
      request: const AdRequest(),
    );
    return _bannerAd!.load();
  }

  Future<void> _showPreloadeAd(PreloadedBannerAd ad) async {
    // It's possible that the banner is still loading (even though it started
    // preloading at the start of the previous screen).
    _adLoadinState = _LoadingState.loading;
    try {
      _bannerAd = await ad.ready;
    } on LoadAdError catch (error) {
      _log.severe('Error when loadin preloaded banner: $error');
      unawaited(_loadAd());
      return;
    }
    if (!mounted) return;
    setState(() {
      _adLoadinState = _LoadingState.loaded;
    });
  }
}

enum _LoadingState {
  /// The state before we even start loading anything.
  initial,

  /// The ad is being loaded at this point.
  loading,

  /// The previous ad is being disposed of. After that is done, the next
  /// ad will be loaded.
  disposing,

  /// An ad has been loaded already.
  loaded,
}
