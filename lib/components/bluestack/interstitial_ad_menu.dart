import 'dart:async';

import 'package:bluestack_flutter_demo/components/loading_indicator.dart';
import 'package:bluestack_flutter_demo/config/app_config.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';
import 'package:flutter/material.dart';

class InterstitialAdMenu extends StatefulWidget {
  const InterstitialAdMenu({super.key});

  @override
  State<InterstitialAdMenu> createState() => _InterstitialAdMenuState();
}

class _InterstitialAdMenuState extends State<InterstitialAdMenu> {
  final RequestOptions _options = AppConfig.getRequestOptions();
  bool _isLoadingInterstitial = false;
  InterstitialAd? _interstitialAd;

  void _handleInterstitialLoaded() {
    setState(() => _isLoadingInterstitial = false);
    LoggerService.showLog(this, 'Interstitial ad loaded');
  }

  void _handleInterstitialFailedToLoad(BlueStackError error) {
    setState(() => _isLoadingInterstitial = false);
    LoggerService.showLog(this, 'Interstitial ad failed to load: $error');
  }

  void _handleInterstitialDisplayed() {
    LoggerService.showLog(this, 'Interstitial ad showed');
  }

  void _handleInterstitialFailedToDisplay(BlueStackError error) {
    LoggerService.showLog(this, 'Interstitial ad failed to display: $error');
  }

  void _handleInterstitialDismissed() {
    LoggerService.showLog(this, 'Interstitial ad closed');
  }

  void _handleInterstitialClicked() {
    LoggerService.showLog(this, 'Interstitial ad clicked');
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _createInterstitialAd() {
    _interstitialAd = InterstitialAd('/${AppConfig.appId}/interstitial');
  }

  void _setupAdLoadCallbacks() {
    // Interstitial ad load callbacks
    _interstitialAd?.setLoadEventListener(
      InterstitialAdLoadEventListener(
        onAdLoaded: _handleInterstitialLoaded,
        onAdFailedToLoad: _handleInterstitialFailedToLoad,
      ),
    );
  }

  void _setupAdShowCallbacks() {
    // Interstitial ad show callbacks
    _interstitialAd?.setShowEventListener(
      InterstitialAdShowEventListener(
        onAdDisplayed: _handleInterstitialDisplayed,
        onAdFailedToDisplay: _handleInterstitialFailedToDisplay,
        onAdDismissed: _handleInterstitialDismissed,
        onAdClicked: _handleInterstitialClicked,
      ),
    );
  }

  void _loadInterstitialAd() {
    _setupAdLoadCallbacks();
    setState(() => _isLoadingInterstitial = true);
    LoggerService.showLog(this, 'Loading Interstitial ad...');
    unawaited(_interstitialAd?.load(options: _options));
  }

  Future<void> _showInterstitialAd() async {
    _setupAdShowCallbacks();
    LoggerService.showLog(this, 'Showing Interstitial ad...');
    await _interstitialAd?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interstitial Ads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _isLoadingInterstitial
                ? const LoadingIndicator(message: 'Loading Interstitial Ad...')
                : Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loadInterstitialAd,
                          child: const Text('Load Interstitial'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showInterstitialAd,
                          child: const Text('Show Interstitial'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
