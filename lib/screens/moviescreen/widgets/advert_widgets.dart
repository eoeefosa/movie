import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/ads/ad_controller.dart';
import 'package:torihd/ads/banner_ad_widget.dart';

class AdvertsWidget extends StatelessWidget {
  const AdvertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;

    return adsControllerAvailable
        ? const Row(
            children: [
              Expanded(
                child: Center(
                  child: BannerAdWidget(),
                ),
              ),
            ],
          )
        : Container();
  }
}
