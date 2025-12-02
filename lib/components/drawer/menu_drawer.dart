import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/bluestack_logo.png',
                  height: 40,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Home'),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      context.go('/');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('BlueStack Ads'),
                    leading: const Icon(Icons.ads_click),
                    onTap: () {
                      context.go('/bluestack');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      context.go('/settings');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
