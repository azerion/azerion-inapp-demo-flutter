import 'package:bluestack_demo_flutter/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogDrawer extends ConsumerStatefulWidget {
  const LogDrawer({super.key});

  @override
  ConsumerState<LogDrawer> createState() => _LogDrawerState();
}

class _LogDrawerState extends ConsumerState<LogDrawer> {
  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(loggerProvider);

    return Drawer(
      child: Column(
        children: [
          SizedBox(
              height: 130,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Application Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_all, color: Colors.white),
                          onPressed: () {
                            final allLogs = logs
                                .map((log) => '$log: ${log.message}')
                                .join('\n');
                            Clipboard.setData(ClipboardData(text: allLogs));
                          },
                          tooltip: 'Copy all logs',
                        ),
                        const IconButton(
                          icon: Icon(Icons.clear_all, color: Colors.white),
                          onPressed: LoggerService.clear,
                          tooltip: 'Clear logs',
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText.rich(
                TextSpan(
                  children: logs
                      .map((log) => TextSpan(
                            text: '$log\n\n',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
