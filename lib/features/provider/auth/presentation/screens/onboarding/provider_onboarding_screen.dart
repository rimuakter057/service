import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';

class _ProviderOnboardingPage {
  final String illustration;
  final String title;
  final String subtitle;
  final String buttonText;

  const _ProviderOnboardingPage({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class ProviderOnboardingScreen extends StatefulWidget {
  static const String routeName = '/provider-onboarding';

  const ProviderOnboardingScreen({super.key});

  @override
  State<ProviderOnboardingScreen> createState() =>
      _ProviderOnboardingScreenState();
}

class _ProviderOnboardingScreenState extends State<ProviderOnboardingScreen> {
  static final List<_ProviderOnboardingPage> _pages = [
    _ProviderOnboardingPage(
      illustration: AssetsPath.providerOnboarding1,
      title: AppText.putYourSkillsToWork,
      subtitle:
          AppText.offerYourSkillsOnNchitoAndConnectWithPeopleLookingForYourServices,
      buttonText: AppText.next,
    ),
    _ProviderOnboardingPage(
      illustration: AssetsPath.providerOnboarding2,
      title: AppText.growYourWork,
      subtitle:
          AppText.reachNewCustomersAndManageYourServiceRequestsInOnePlace,
      buttonText: AppText.next,
    ),
    _ProviderOnboardingPage(
      illustration: AssetsPath.providerOnboarding3,
      title: AppText.workEarnGrow,
      subtitle:
          AppText.completeJobsBuildYourReputationAndGrowYourEarningsWithNchito,
      buttonText: AppText.continueButton,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToHome() => context.go(ProviderHomeScreen.routeName);

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
      _goToHome();
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
                    onTap: _goToHome,
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
                              width: double.infinity,
                              height: ResponsiveHelper.height(350),
                              fit: BoxFit.contain,
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
