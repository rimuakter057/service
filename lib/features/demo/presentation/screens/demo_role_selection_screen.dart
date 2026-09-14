import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/auth/presentation/screens/age_confirmation/provider_age_confirmation_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/login/provider_login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/role_selection/role_selection_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';

enum DemoRole { user, provider }

/// Demo role selection screen displayed right after splash screen.
/// Routes to the respective Authentication section (User Auth or Provider Auth)
/// with full support for Login, Sign Up, OTP, Identity Verification and Payments.
/// Also re-appears whenever logout is confirmed from the profile screen.
class DemoRoleSelectionScreen extends StatefulWidget {
  static const String routeName = '/demo-role-selection';

  const DemoRoleSelectionScreen({super.key});

  @override
  State<DemoRoleSelectionScreen> createState() =>
      _DemoRoleSelectionScreenState();
}

class _DemoRoleSelectionScreenState extends State<DemoRoleSelectionScreen> {
  DemoRole _selectedRole = DemoRole.user;

  void _onContinueToLogin() {
    if (_selectedRole == DemoRole.provider) {
      context.push(ProviderLoginScreen.routeName);
    } else {
      context.push(LoginScreen.routeName);
    }
  }

  void _onContinueToSignUp() {
    if (_selectedRole == DemoRole.provider) {
      context.push(ProviderAgeConfirmationScreen.routeName);
    } else {
      context.push(SignUpScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                    vertical: ResponsiveHelper.padding(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(12)),

                      // App Logo
                      Center(
                        child: SvgPicture.asset(
                          AssetsPath.splashIcon,
                          height: ResponsiveHelper.height(44),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),

                      // Demo Badge
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(14),
                            vertical: ResponsiveHelper.padding(6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandSoft,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(20),
                            ),
                            border: Border.all(
                              color: AppColors.brandPrimary.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Text(
                            'SELECT AUTH SECTION',
                            style: context.labelSmall.copyWith(
                              color: AppColors.brandPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),

                      // Heading
                      Text(
                        'Select Your Role',
                        textAlign: TextAlign.center,
                        style: context.headlineSmall.copyWith(
                          color: AppColors.textBlackPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(8)),
                      Text(
                        'Choose User or Provider to enter its dedicated authentication flow.',
                        textAlign: TextAlign.center,
                        style: context.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      // Option 1: Customer (User) Auth Flow
                      _DemoRoleCard(
                        roleName: 'Customer / User',
                        badgeText: 'USER AUTH FLOW',
                        description:
                            'Sign In or Register with Email, Password & OTP verification to explore customer home and bookings.',
                        icon: Icons.person_rounded,
                        isSelected: _selectedRole == DemoRole.user,
                        onTap: () {
                          setState(() => _selectedRole = DemoRole.user);
                        },
                        onLoginTap: () {
                          context.push(LoginScreen.routeName);
                        },
                        onSignUpTap: () {
                          context.push(SignUpScreen.routeName);
                        },
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(16)),

                      // Option 2: Service Provider Auth Flow
                      _DemoRoleCard(
                        roleName: 'Service Provider',
                        badgeText: 'PROVIDER AUTH FLOW',
                        description:
                            'Sign In or Register with ID Verification & Payments setup to explore provider job management.',
                        icon: Icons.handyman_rounded,
                        isSelected: _selectedRole == DemoRole.provider,
                        onTap: () {
                          setState(() => _selectedRole = DemoRole.provider);
                        },
                        onLoginTap: () {
                          context.push(ProviderLoginScreen.routeName);
                        },
                        onSignUpTap: () {
                          context.push(ProviderAgeConfirmationScreen.routeName);
                        },
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(28)),

                      // Main Login Button
                      AppButton(
                        text: _selectedRole == DemoRole.user
                            ? 'Continue to User Log In'
                            : 'Continue to Provider Log In',
                        backgroundColor: AppColors.brandPrimary,
                        textColor: AppColors.white,
                        onPressed: _onContinueToLogin,
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(12)),

                      // Secondary Sign Up Button
                      AppButton(
                        text: _selectedRole == DemoRole.user
                            ? 'Sign Up as Customer'
                            : 'Sign Up as Service Provider',
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.brandPrimary,
                        textColor: AppColors.brandPrimary,
                        onPressed: _onContinueToSignUp,
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(20)),

                      // Links for other auth screens
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () =>
                                context.push(OnboardingScreen.routeName),
                            child: Text(
                              'Onboarding',
                              style: context.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(color: AppColors.textDisabled),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(RoleSelectionScreen.routeName),
                            child: Text(
                              'Role Selection Flow',
                              style: context.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(8)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DemoRoleCard extends StatelessWidget {
  final String roleName;
  final String badgeText;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  const _DemoRoleCard({
    required this.roleName,
    required this.badgeText,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: isSelected ? AppColors.brandSoft : AppColors.white,
        border: Border.all(
          color: isSelected ? AppColors.brandPrimary : AppColors.borderDefault,
          width: isSelected ? 2 : 1,
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ResponsiveHelper.width(44),
                    height: ResponsiveHelper.height(44),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(12),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.brandPrimary,
                      size: ResponsiveHelper.iconSize(24),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(8),
                            vertical: ResponsiveHelper.padding(2),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.brandPrimary.withValues(alpha: 0.12)
                                : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(6),
                            ),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(10),
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.brandPrimary
                                  : AppColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(4)),
                        Text(
                          roleName,
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ResponsiveHelper.width(22),
                    height: ResponsiveHelper.height(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brandPrimary
                            : AppColors.borderDefault,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppColors.brandPrimary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),
              Text(
                description,
                style: context.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onSignUpTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(14),
                        vertical: ResponsiveHelper.padding(8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandPrimary
                              : AppColors.borderDefault,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(8),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  GestureDetector(
                    onTap: onLoginTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(16),
                        vertical: ResponsiveHelper.padding(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(4)),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
