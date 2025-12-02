import 'package:bluestack_demo_flutter/components/loading_indicator.dart';
import 'package:bluestack_demo_flutter/config/app_config.dart';
import 'package:bluestack_demo_flutter/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';
import 'package:flutter/material.dart';

class RewardedAdMenu extends StatefulWidget {
  const RewardedAdMenu({super.key});

  @override
  State<RewardedAdMenu> createState() => _RewardedAdMenuState();
}

class _RewardedAdMenuState extends State<RewardedAdMenu> {
  final RequestOptions _options = AppConfig.getRequestOptions();
  bool _isLoadingRewarded = false;
  RewardedAd? _rewardedAd;

  void _handleRewardedLoaded() {
    setState(() => _isLoadingRewarded = false);
    LoggerService.showLog(this, 'Rewarded ad loaded');
  }

  void _handleRewardedFailedToLoad(BlueStackError error) {
    setState(() => _isLoadingRewarded = false);
    LoggerService.showLog(this, 'Rewarded ad failed to load: $error');
  }

  void _handleRewardedDisplayed() {
    LoggerService.showLog(this, 'Rewarded ad showed');
  }

  void _handleRewardedFailedToDisplay(BlueStackError error) {
    LoggerService.showLog(this, 'Rewarded ad failed to display: $error');
  }

  void _handleRewardedDismissed() {
    LoggerService.showLog(this, 'Rewarded ad closed');
  }

  void _handleRewardedClicked() {
    LoggerService.showLog(this, 'Rewarded ad clicked');
  }

  void _handleRewardEarned(RewardItem reward) {
    LoggerService.showLog(this, 'Reward earned: $reward');
  }

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _createRewardedAd() {
    _rewardedAd = RewardedAd('/${AppConfig.appId}/rewardedVideo');
  }

  void _setupAdLoadCallbacks() {
    // Rewarded ad load callbacks
    _rewardedAd?.setLoadEventListener(RewardedAdLoadEventListener(
      onAdLoaded: _handleRewardedLoaded,
      onAdFailedToLoad: _handleRewardedFailedToLoad,
    ));
  }

  void _setupAdShowCallbacks() {
    // Rewarded ad show callbacks
    _rewardedAd?.setShowEventListener(RewardedAdShowEventListener(
      onAdDisplayed: _handleRewardedDisplayed,
      onAdFailedToDisplay: _handleRewardedFailedToDisplay,
      onAdDismissed: _handleRewardedDismissed,
      onAdClicked: _handleRewardedClicked,
      onRewarded: _handleRewardEarned,
    ));
  }

  void _loadRewardedAd() {
    _setupAdLoadCallbacks();
    setState(() => _isLoadingRewarded = true);
    LoggerService.showLog(this, 'Loading Rewarded ad...');
    _loadRewardedAdAsync();
  }

  Future<void> _loadRewardedAdAsync() async {
    await _rewardedAd?.load(options: _options);
  }

  Future<void> _showRewardedAd() async {
    _setupAdShowCallbacks();
    LoggerService.showLog(this, 'Showing Rewarded ad...');
    await _rewardedAd?.show();
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
              'Rewarded Ads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _isLoadingRewarded
                ? const LoadingIndicator(message: 'Loading Rewarded Ad...')
                : Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loadRewardedAd,
                          child: const Text('Load Rewarded'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showRewardedAd,
                          child: const Text('Show Rewarded'),
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
