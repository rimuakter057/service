import 'package:flutter/material.dart';
import 'core/helper/responsive_helper/responsive_helper.dart';
import 'core/utils/app_theme/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/user/auth/presentation/screens/login/login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      builder: (context, child) => ResponsiveWrapper(child: child!),
      home: LoginScreen(),
    );
  }
}

