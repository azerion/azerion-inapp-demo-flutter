import 'dart:async';

import 'package:bluestack_flutter_demo/components/drawer/log_drawer.dart';
import 'package:bluestack_flutter_demo/components/drawer/menu_drawer.dart';
import 'package:bluestack_flutter_demo/internal/internal_features.dart';
import 'package:bluestack_flutter_demo/providers/bluestack_provider.dart';
import 'package:bluestack_flutter_demo/screens/banner_screen.dart';
import 'package:bluestack_flutter_demo/screens/bluestack_screen.dart';
import 'package:bluestack_flutter_demo/screens/home_screen.dart';
import 'package:bluestack_flutter_demo/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class BlueStackApp extends ConsumerStatefulWidget {
  BlueStackApp({super.key});

  final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (_, _, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const HomeScreen(),
          ),
          GoRoute(
            path: '/bluestack',
            builder: (_, _) => const BlueStackScreen(),
          ),
          GoRoute(
            path: '/banner',
            builder: (_, _) => const BannerScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
          ...internalFeatures.map((feature) => feature.route),
        ],
      ),
    ],
  );

  @override
  ConsumerState<BlueStackApp> createState() => _BlueStackAppState();
}

class _BlueStackAppState extends ConsumerState<BlueStackApp> {
  @override
  void initState() {
    super.initState();
    unawaited(_initializeBlueStack());
  }

  Future<void> _initializeBlueStack() async {
    if (ref.read(bluestackInitializedProvider)) return;
    await BlueStackService.initialize(ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BlueStack Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      routerConfig: widget._router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _AppShell extends StatefulWidget {
  final Widget child;

  const _AppShell({required this.child});

  @override
  __AppShellState createState() => __AppShellState();
}

class __AppShellState extends State<_AppShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('BlueStack Demo'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.article),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const LogDrawer(),
      body: widget.child,
    );
  }
}
