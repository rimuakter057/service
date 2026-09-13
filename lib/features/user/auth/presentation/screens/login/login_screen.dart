import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/core/common_widgets/app_divider/app_divider.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/constants/user_role.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:nchito/core/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';
import 'package:nchito/features/user/auth/presentation/widgets/social_icon_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  final UserRole role;

  const LoginScreen({super.key, this.role = UserRole.user});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // TODO: remove test-only default values before release
  late final TextEditingController _emailController = TextEditingController(
    text: widget.role == UserRole.provider
        ? 'provider@nchito.com'
        : 'test@nchito.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'test1234',
  );

  bool _rememberMe = false;
  bool _obscurePassword = true;

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.role == UserRole.provider) {
        context.go(ProviderHomeScreen.routeName);
      } else {
        context.go(HomeScreen.routeName);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                    vertical: ResponsiveHelper.padding(32),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context.canPop()) ...[
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: ResponsiveHelper.width(36),
                              height: ResponsiveHelper.height(36),
                              decoration: const BoxDecoration(
                                color: AppColors.brandSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.brandPrimary,
                                size: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(16)),
                        ],
                        AuthHeader(
                          title: widget.role == UserRole.provider
                              ? 'Provider Log In'
                              : AppText.welcomeBack,
                          subtitle: widget.role == UserRole.provider
                              ? 'Log in to continue managing your provider account'
                              : AppText.logInToContinueWithNchito,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),

                        // Email Address
                        AppTextField(
                          label: AppText.emailAddress,
                          hint: AppText.enterYourEmailAddress,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20)),

                        ///===================== Password
                        AppTextField(
                          label: AppText.password,
                          hint: AppText.enterYourPassword,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: Validators.password,
                          suffixIcon: IconButton(
                            icon: AppIcon(
                              assetPath: AssetsPath.logInIconEyeToggle,
                              size: ResponsiveHelper.iconSize(16),
                              color: AppTheme.inputIconColor,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        /// Remember me / Forgot password======================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _rememberMe = !_rememberMe,
                                  ),
                                  child: SvgPicture.asset(
                                    _rememberMe
                                        ? AssetsPath.logInIconCheckboxChecked
                                        : AssetsPath.logInIconCheckboxUnchecked,
                                    width: ResponsiveHelper.iconSize(20),
                                    height: ResponsiveHelper.iconSize(20),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(8)),
                                Text(
                                  AppText.rememberMe,
                                  style: context.displaySmall,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.push(ForgotPasswordScreen.routeName),
                              child: Text(
                                AppText.forgotPassword,
                                style: context.bodyMedium.copyWith(
                                  color: AppColors.blueStatusInfo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        ///======================== Log In button
                        ElevatedButton(
                          onPressed: _onLoginPressed,
                          child: Text(AppText.logIn),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        ///========================= Or continue with
                        Row(
                          children: [
                            const Expanded(child: AppDivider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.padding(12),
                              ),
                              child: Text(
                                AppText.orContinueWith,
                                style: context.displaySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Expanded(child: AppDivider()),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        /// =============================Social buttons======================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialIconButton(
                              assetPath: AssetsPath.logInIconSocialGoogle,
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(16)),
                            SocialIconButton(
                              assetPath: AssetsPath.logInIconSocialApple,
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),

                        ///==================== No account yet! Create an account !
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                AppText.noAccountYet,
                                style: context.displaySmall,
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(4)),
                              GestureDetector(
                                onTap: () => context.push(
                                  SignUpScreen.routeName,
                                  extra: widget.role,
                                ),
                                child: Text(
                                  AppText.createAnAccount,
                                  style: context.displaySmall.copyWith(
                                    color: AppColors.blueStatusInfo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
