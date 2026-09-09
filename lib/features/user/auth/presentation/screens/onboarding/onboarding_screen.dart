import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';

class _OnboardingPage {
  final String illustration;
  final String title;
  final String subtitle;
  final String buttonText;

  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      illustration: AssetsPath.onboarding01IllustrationHero,
      title: AppText.findTheHelpYouNeed,
      subtitle:
          AppText.discoverLocalProfessionalsReadyToHelpWithEverydayServices,
      buttonText: AppText.next,
    ),
    _OnboardingPage(
      illustration: AssetsPath.onboarding05IllustrationHero,
      title: AppText.chooseWithConfidence,
      subtitle: AppText
          .exploreServicesCompareProfessionalsAndFindTheRightFitForYourNeeds,
      buttonText: AppText.next,
    ),
    _OnboardingPage(
      illustration: AssetsPath.onboarding04IllustrationHero,
      title: AppText.bookItYourWay,
      subtitle: AppText.chooseAConvenientTimeAndGetYourServiceSortedWithEase,
      buttonText: AppText.continueButton,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToLogin() => context.go(LoginScreen.routeName);

  void _onBackPressed() {
    if (_currentPage == 0) {
      if (context.canPop()) context.pop();
      return;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNextPressed() {
    if (_currentPage == _pages.length - 1) {
      _goToLogin();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.width(3)),
          height: ResponsiveHelper.height(6),
          width: isActive
              ? ResponsiveHelper.width(32)
              : ResponsiveHelper.width(6),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.brandPrimary
                : AppColors.brandPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ResponsiveHelper.width(6)),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onBackPressed,
                    child: BgIcon(
                      assetPath: AssetsPath.onboarding01IconBack,
                      bgColor: AppColors.brandSoft,
                      iconColor: AppColors.brandPrimary,
                      bgSize: ResponsiveHelper.width(40),
                      radius: ResponsiveHelper.width(20),
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToLogin,
                    child: Text(
                      AppText.skip,
                      style: context.labelLarge.copyWith(
                        color: AppColors.blueStatusInfo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: ResponsiveHelper.height(350),
                          width: double.infinity,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.55, 0.95],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: AppIcon(
                              assetPath: page.illustration,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(24),
                          ),
                          child: Column(
                            children: [
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: context.titleLarge.copyWith(
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: context.titleSmall,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(20)),
                              _buildPageIndicator(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.padding(24)),
              child: ElevatedButton(
                onPressed: _onNextPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_pages[_currentPage].buttonText),
                    SizedBox(width: ResponsiveHelper.spacing(6)),
                    AppIcon(
                      assetPath: AssetsPath.onboarding01IconArrowNext,
                      size: ResponsiveHelper.iconSize(16),
                      color: AppColors.textOnPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
