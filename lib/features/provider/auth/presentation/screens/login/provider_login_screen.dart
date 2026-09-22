import 'package:flutter/material.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';

/// Legacy Provider Login route — delegates directly to the unified [LoginScreen].
class ProviderLoginScreen extends StatelessWidget {
  static const String routeName = '/provider/login';

  const ProviderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
