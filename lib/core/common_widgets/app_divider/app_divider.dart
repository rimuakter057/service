import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets_path/assets_path.dart';

/// Reusable horizontal divider line (e.g. the "Or continue with" rule on
/// the Log In screen). Stretches to fill whatever width it's given —
/// wrap it in an [Expanded] or [SizedBox].
class AppDivider extends StatelessWidget {
  final String assetPath;
  final double height;

  const AppDivider({
    super.key,
    this.assetPath = AssetsPath.logInDividerLine,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetPath, height: height, fit: BoxFit.fill);
  }
}
