import 'dart:async';

import 'package:bluestack_flutter_demo/config/app_config.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';
import 'package:flutter/material.dart';

class BannerAdMenu extends StatefulWidget {
  const BannerAdMenu({super.key});

  @override
  State<BannerAdMenu> createState() => _BannerAdMenuState();
}

class _BannerAdMenuState extends State<BannerAdMenu> {
  bool _isBannerVisible = false;
  bool _isBannerRefreshing = false;
  final RequestOptions _options = AppConfig.getRequestOptions();
  final GlobalKey<BannerViewState> _bannerViewKey =
      GlobalKey<BannerViewState>();

  void _handleBannerLoaded(dynamic size) {
    setState(() => _isBannerVisible = true);
    LoggerService.showLog(this, 'Banner ad loaded with size: $size');
  }

  void _handleBannerFailedToLoad(BlueStackError error) {
    setState(() => _isBannerVisible = false);
    LoggerService.showLog(this, 'Banner ad failed to load: $error');
  }

  void _handleBannerClicked() {
    LoggerService.showLog(this, 'Banner ad clicked');
  }

  void _handleBannerRefreshed() {
    setState(() => _isBannerRefreshing = true);
    LoggerService.showLog(this, 'Banner ad refreshed');
  }

  void _handleBannerFailedToRefresh(BlueStackError error) {
    setState(() => _isBannerRefreshing = false);
    LoggerService.showLog(this, 'Banner ad failed to refresh: $error');
  }

  /// Loads the banner ad using the current [RequestOptions].
  void _loadBannerAd() {
    LoggerService.showLog(this, 'Loading banner ad...');
    unawaited(_bannerViewKey.currentState?.load(options: _options));
  }

  /// Toggles the visibility of the banner ad.
  void _toggleBannerAdVisibility() {
    _bannerViewKey.currentState?.toggleVisibility(!_isBannerVisible);
    setState(() => _isBannerVisible = !_isBannerVisible);
  }

  /// Starts or stops the automatic refresh of the banner ad.
  void _toggleBannerAdRefresh() {
    unawaited(_bannerViewKey.currentState?.toggleRefresh(!_isBannerRefreshing));
    setState(() => _isBannerRefreshing = !_isBannerRefreshing);
  }

  /// Destroys the banner ad and releases its resources.
  void _destroyBannerAd() {
    LoggerService.showLog(this, 'Destroying Banner ad');
    unawaited(_bannerViewKey.currentState?.destroy());
    setState(() {
      _isBannerVisible = false;
      _isBannerRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Banner Ads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _loadBannerAd,
                  child: const Text('Load banner'),
                ),
                ElevatedButton(
                  onPressed: _toggleBannerAdRefresh,
                  child: Text(
                    _isBannerRefreshing ? 'Stop Refresh' : 'Start Refresh',
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _toggleBannerAdVisibility,
                  child: Text(_isBannerVisible ? 'Hide banner' : 'Show banner'),
                ),
                ElevatedButton(
                  onPressed: _destroyBannerAd,
                  child: const Text('Destroy banner'),
                ),
              ],
            ),
            BannerView(
              key: _bannerViewKey,
              type: BannerAdSize.banner,
              placementId: '/${AppConfig.appId}/banner',
              options: _options,
              onAdLoaded: _handleBannerLoaded,
              onAdFailedToLoad: _handleBannerFailedToLoad,
              onAdClicked: _handleBannerClicked,
              onAdRefreshed: _handleBannerRefreshed,
              onAdFailedToRefresh: _handleBannerFailedToRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
