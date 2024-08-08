// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:logging/logging.dart';

// class PreloadedBannerAd {
//   static final _log = Logger("PreloadedBannerAd");

//   /// something like [AdSize.meduimRectangle].
//   final AdSize size;
//   final AdRequest _adRequest;
//   BannerAd? _bannerAd;
//   final String adUnitId;
//   final _adCompleter = Completer<BannerAd>();

//   PreloadedBannerAd({
//     required this.size,
//     AdRequest? adRequest,
//     required this.adUnitId,
//   }) : _adRequest = adRequest ?? const AdRequest();

//   Future<BannerAd> get ready => _adCompleter.future;

//   Future<void> load() {
//     _bannerAd = BannerAd(
//       size: size,
//       adUnitId: adUnitId,
//       request: _adRequest,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           _log.info(() => 'Ad loaded: ${_bannerAd.hashCode}');
//           _adCompleter.complete(_bannerAd);
//         },
//         onAdFailedToLoad: (ad, error) {
//           _log.warning('Banner faildToLoad: $error');
//           _adCompleter.completeError(error);
//           ad.dispose();
//         },
//         onAdImpression: (ad) {
//           _log.info('Ad impression registered');
//         },
//         onAdClicked: (ad) {
//           _log.info('Ad click registered');
//         },
//       ),
//     );

//     return _bannerAd!.load();
//   }

//   void dispose() {
//     _log.info('preloaded banner ad being disposed');
//     _bannerAd?.dispose();
//   }
// }
