import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_pocketpartners/core/controllers/theme_controller.dart';
import 'package:mobile_app_pocketpartners/core/router/router.dart';

void main() async {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
    );
  }
}
