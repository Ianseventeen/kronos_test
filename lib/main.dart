import 'package:flutter/material.dart';

import 'core/di/getit.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(
    MediaQuery.withClampedTextScaling(
      child: KronosApp(),
      maxScaleFactor: 1.2,
      minScaleFactor: 0.8,
    ),
  );
}

class KronosApp extends StatelessWidget {
  const KronosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kronos',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
