import 'package:bluestack_demo_flutter/components/drawer/log_drawer.dart';
import 'package:bluestack_demo_flutter/components/drawer/menu_drawer.dart';
import 'package:bluestack_demo_flutter/providers/bluestack_provider.dart';
import 'package:bluestack_demo_flutter/screens/bluestack_screen.dart';
import 'package:bluestack_demo_flutter/screens/home_screen.dart';
import 'package:bluestack_demo_flutter/screens/settings_screen.dart';
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
        builder: (_, __, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/bluestack',
            builder: (_, __) => const BlueStackScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
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
    _initializeBlueStack();
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
      body: Stack(
        children: [
          widget.child,
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
