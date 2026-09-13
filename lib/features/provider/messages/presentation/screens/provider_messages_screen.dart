import 'package:flutter/material.dart';
import 'package:nchito/features/user/messages/presentation/screens/messages_screen.dart';

/// Provider Messages screen — reuses [MessagesScreen] in provider mode with
/// [ProviderBottomNavBar].
class ProviderMessagesScreen extends StatelessWidget {
  static const String routeName = '/provider/messages';

  const ProviderMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MessagesScreen(isProvider: true);
  }
}
