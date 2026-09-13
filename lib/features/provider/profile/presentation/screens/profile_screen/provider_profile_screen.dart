import 'package:flutter/material.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';

/// Provider Profile screen — reuses the user [ProfileScreen] in provider mode
/// with [ProviderBottomNavBar].
class ProviderProfileScreen extends StatelessWidget {
  static const String routeName = '/provider/profile';

  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(isProvider: true);
  }
}
