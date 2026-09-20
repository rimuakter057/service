import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/network/token_storage.dart';
import 'package:nchito/features/common/role_selection/role_selection_screen.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await TokenStorage.read();
    final role = await TokenStorage.readRole();
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == 'provider') {
        context.go(ProviderHomeScreen.routeName);
      } else {
        context.go(HomeScreen.routeName);
      }
    } else {
      context.go(RoleSelectionScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(AssetsPath.splashIcon)),
    );
  }
}
