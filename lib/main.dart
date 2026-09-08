import 'package:flutter/material.dart';
import 'core/helper/responsive_helper/responsive_helper.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) => ResponsiveWrapper(child: child!),
      home: LoginScreen(),
    );
  }
}

