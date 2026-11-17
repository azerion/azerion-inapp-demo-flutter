import 'dart:async';

import 'package:bluestack_flutter_demo/config/app_config.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';
import 'package:flutter/material.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  // Tab configuration: display name -> BannerAdSize
  final List<Map<String, dynamic>> _bannerTabs = [
    {'name': 'Standard', 'type': BannerAdSize.banner},
    {'name': 'Full', 'type': BannerAdSize.fullBanner},
    {'name': 'Large', 'type': BannerAdSize.largeBanner},
    {'name': 'Leaderboard', 'type': BannerAdSize.leaderboard},
    {'name': 'MREC', 'type': BannerAdSize.mediumRectangle},
  ];

  // State for each banner tab
  final Map<BannerAdSize, BannerState> _bannerStates = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _bannerTabs.length, vsync: this);

    // Initialize banner states
    for (final tab in _bannerTabs) {
      _bannerStates[tab['type'] as BannerAdSize] = BannerState();
    }

    // Add scroll listener to update arrow visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollArrows();
      _tabScrollController.addListener(_updateScrollArrows);
    });

    // Add listener to update UI when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _updateScrollArrows() {
    if (_tabScrollController.hasClients) {
      setState(() {
        _canScrollLeft = _tabScrollController.offset > 0;
        _canScrollRight =
            _tabScrollController.offset <
            _tabScrollController.position.maxScrollExtent;
      });
    }
  }

  void _scrollTabs(bool left) {
    const scrollAmount = 100.0;
    if (left) {
      unawaited(
        _tabScrollController.animateTo(
          _tabScrollController.offset - scrollAmount,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    } else {
      unawaited(
        _tabScrollController.animateTo(
          _tabScrollController.offset + scrollAmount,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Tab bar with arrow buttons
          Container(
            height: 48,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 23, 23, 23),
            ),
            child: Row(
              children: [
                // Left arrow
                if (_canScrollLeft)
                  Container(
                    color: Colors.grey[850],
                    width: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () => _scrollTabs(true),
                      padding: const EdgeInsets.all(8),
                    ),
                  )
                else
                  const SizedBox(width: 0),
                // Tabs
                Expanded(
                  child: SingleChildScrollView(
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_bannerTabs.length, (index) {
                        final isSelected = _tabController.index == index;
                        final isLast = index == _bannerTabs.length - 1;

                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _tabController.animateTo(index);
                              },
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF7B2FBE)
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _bannerTabs[index]['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 1,
                                height: double.infinity,
                                color: const Color.fromARGB(255, 46, 46, 46),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),

                // Right arrow
                if (_canScrollRight)
                  Container(
                    color: Colors.grey[850],
                    width: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () => _scrollTabs(false),
                      padding: const EdgeInsets.all(8),
                    ),
                  )
                else
                  const SizedBox(width: 0),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _bannerTabs.map((tab) {
                return _buildBannerTab(tab['type'] as BannerAdSize);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerTab(BannerAdSize bannerType) {
    final state = _bannerStates[bannerType]!;
    return Column(
      children: [
        // Control buttons at top
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Control buttons row 1
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Load',
                      () => _loadBanner(bannerType),
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      state.isVisible ? 'Hide' : 'Show',
                      () => _toggleVisibility(bannerType),
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Control buttons row 2
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Toggle Refresh',
                      () => _toggleRefresh(bannerType),
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Remove',
                      () => _removeBanner(bannerType),
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildPlaceholderContent(bannerType),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onPressed, {
    bool isPrimary = false,
    bool enabled = true,
  }) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color.fromARGB(255, 123, 47, 190)
              : const Color.fromARGB(255, 113, 34, 182),
          foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent(BannerAdSize bannerType) {
    final state = _bannerStates[bannerType]!;
    return Column(
      children: [
        // Large placeholder
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 20),

        // Row with image and text placeholders
        Image.asset(
          'assets/images/content_left.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 60,
              color: Colors.grey[300],
              child: const Center(
                child: Text('Content Placeholder'),
              ),
            );
          },
        ),

        // Banner view
        BannerView(
          key: state.bannerKey,
          type: bannerType,
          shouldLoadWhenReady: true,
          placementId: '/${AppConfig.appId}/banner',
          options: AppConfig.getRequestOptions(),
          onAdLoaded: (_) => _handleBannerLoaded(bannerType),
          onAdFailedToLoad: (error) =>
              _handleBannerFailedToLoad(bannerType, error),
          onAdClicked: () => _handleBannerClicked(bannerType),
          onAdRefreshed: () => _handleBannerRefreshed(bannerType),
          onAdFailedToRefresh: (error) =>
              _handleBannerFailedToRefresh(bannerType, error),
        ),
        const SizedBox(height: 20),

        // Row with image and text placeholders
        Image.asset(
          'assets/images/content_right.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 60,
              color: Colors.grey[300],
              child: const Center(
                child: Text('Content Placeholder'),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        // Large placeholder
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Banner event handlers
  void _loadBanner(BannerAdSize type) {
    final state = _bannerStates[type]!;
    LoggerService.showLog(this, 'Loading ${type.name} ad...');
    unawaited(
      state.bannerKey.currentState?.load(
        options: AppConfig.getRequestOptions(),
      ),
    );
  }

  void _toggleVisibility(BannerAdSize type) {
    final state = _bannerStates[type]!;
    setState(() {
      state.isVisible = !state.isVisible;
    });
    state.bannerKey.currentState?.toggleVisibility(state.isVisible);
    LoggerService.showLog(
      this,
      '${type.name} banner ${state.isVisible ? "shown" : "hidden"}',
    );
  }

  void _toggleRefresh(BannerAdSize type) {
    final state = _bannerStates[type]!;
    setState(() {
      state.isRefreshing = !state.isRefreshing;
    });
    unawaited(state.bannerKey.currentState?.toggleRefresh(state.isRefreshing));
    LoggerService.showLog(
      this,
      '${type.name} refresh ${state.isRefreshing ? "enabled" : "disabled"}',
    );
  }

  void _removeBanner(BannerAdSize type) {
    final state = _bannerStates[type]!;
    LoggerService.showLog(this, 'Removing ${type.name} banner');
    unawaited(state.bannerKey.currentState?.destroy());
    setState(() {
      state
        ..isVisible = false
        ..isLoaded = false
        ..isRefreshing = false;
    });
  }

  void _handleBannerLoaded(BannerAdSize type) {
    setState(() {
      _bannerStates[type]!.isVisible = true;
      _bannerStates[type]!.isLoaded = true;
    });
    LoggerService.showLog(this, '${type.name} banner loaded');
  }

  void _handleBannerFailedToLoad(BannerAdSize type, BlueStackError error) {
    setState(() {
      _bannerStates[type]!.isVisible = false;
      _bannerStates[type]!.isLoaded = false;
    });
    LoggerService.showLog(this, '${type.name} banner failed to load: $error');
  }

  void _handleBannerClicked(BannerAdSize type) {
    LoggerService.showLog(this, '${type.name} banner clicked');
  }

  void _handleBannerRefreshed(BannerAdSize type) {
    setState(() {
      _bannerStates[type]!.isRefreshing = true;
    });
    LoggerService.showLog(this, '${type.name} banner refreshed');
  }

  void _handleBannerFailedToRefresh(BannerAdSize type, BlueStackError error) {
    setState(() {
      _bannerStates[type]!.isRefreshing = false;
    });
    LoggerService.showLog(
      this,
      '${type.name} banner failed to refresh: $error',
    );
  }
}

// Helper class to manage banner state for each tab
class BannerState {
  bool isLoaded = false;
  bool isVisible = false;
  bool isRefreshing = false;
  final GlobalKey<BannerViewState> bannerKey = GlobalKey<BannerViewState>();
}
