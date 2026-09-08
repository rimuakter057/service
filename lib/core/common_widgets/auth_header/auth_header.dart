import 'package:flutter/material.dart';

import '../../extensions/context_extension/context_extension.dart';
import '../../helper/responsive_helper/responsive_helper.dart';

/// Title + subtitle header used at the top of every auth screen
/// (Login, Sign Up, Forgot Password, Verify OTP, ...). Color/style/
/// spacing are fixed — just pass the two strings.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.titleLarge),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        Text(subtitle, style: context.titleSmall),
      ],
    );
  }
}
