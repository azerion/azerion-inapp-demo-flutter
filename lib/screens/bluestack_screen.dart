import 'package:bluestack_flutter_demo/components/bluestack/banner_ad_menu.dart';
import 'package:bluestack_flutter_demo/components/bluestack/interstitial_ad_menu.dart';
import 'package:bluestack_flutter_demo/components/bluestack/rewarded_ad_menu.dart';
import 'package:bluestack_flutter_demo/components/loading_indicator.dart';
import 'package:bluestack_flutter_demo/providers/bluestack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlueStackScreen extends ConsumerWidget {
  const BlueStackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialized = ref.watch(bluestackInitializedProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isInitialized
            ? const Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BannerAdMenu(),
                  InterstitialAdMenu(),
                  RewardedAdMenu(),
                ],
              )
            : const LoadingIndicator(message: 'Initializing BlueStack SDK...'),
      ),
    );
  }
}
