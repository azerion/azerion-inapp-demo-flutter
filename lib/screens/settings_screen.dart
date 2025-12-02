import 'package:bluestack_demo_flutter/config/app_config.dart';
import 'package:bluestack_demo_flutter/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('App ID'),
            subtitle: Text(AppConfig.appId),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              LoggerService.log('App ID tapped: ${AppConfig.appId}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Current App ID: ${AppConfig.appId}'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Debug Mode'),
                subtitle: const Text('Enable detailed logging'),
                value: true, // TODO: Implement debug mode toggle
                onChanged: (value) {
                  LoggerService.log('Debug mode toggled: $value');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Debug mode setting will be implemented soon'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Clear Log History'),
                leading: const Icon(Icons.delete_outline),
                onTap: () {
                  LoggerService.clear();
                  LoggerService.log('Log history cleared');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Log history has been cleared'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            title: const Text('About'),
            subtitle: const Text('BlueStack Demo App'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              LoggerService.log('About section opened');
              showAboutDialog(
                context: context,
                applicationName: 'BlueStack Demo',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 64),
                children: const [
                  Text('A Flutter implementation of the BlueStack Demo app.'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
