import 'package:flutter/material.dart';
import 'core/helper/responsive_helper/responsive_helper.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      builder: (context, child) => ResponsiveWrapper(child: child!),
      routerConfig: AppRouter.router,
    );
  }
}
