import 'package:bluestack_flutter_demo/components/loading_indicator.dart';
import 'package:bluestack_flutter_demo/config/app_config.dart';
import 'package:bluestack_flutter_demo/providers/bluestack_provider.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _handleBannerLoaded(dynamic size) {
    LoggerService.showLog(this, 'Banner ad loaded with size: $size');
  }

  void _handleBannerFailedToLoad(BlueStackError error) {
    LoggerService.showLog(this, 'Banner ad failed to load: $error');
  }

  void _handleBannerClicked() {
    LoggerService.showLog(this, 'Banner ad clicked');
  }

  void _handleBannerRefreshed() {
    LoggerService.showLog(this, 'Banner ad refreshed');
  }

  void _handleBannerFailedToRefresh(BlueStackError error) {
    LoggerService.showLog(this, 'Banner ad failed to refresh: $error');
  }

  @override
  void initState() {
    super.initState();
    // _initializeBlueStack();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = ref.watch(bluestackInitializedProvider);
    final options = RequestOptions();
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bluestack_logo.png',
              height: 150,
            ),
            if (isInitialized)
              BannerView(
                type: BannerAdSize.mediumRectangle,
                placementId: '/${AppConfig.appId}/mrec', //mrec
                shouldLoadWhenReady: true,
                options: options,
                onAdLoaded: _handleBannerLoaded,
                onAdFailedToLoad: _handleBannerFailedToLoad,
                onAdClicked: _handleBannerClicked,
                onAdRefreshed: _handleBannerRefreshed,
                onAdFailedToRefresh: _handleBannerFailedToRefresh,
              )
            else
              const LoadingIndicator(message: 'Initializing BlueStack SDK...'),
            ElevatedButton(
              onPressed: () {
                context.go('/bluestack');
              },
              child: const Text('Go to Ads Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
