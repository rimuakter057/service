import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/provider/auth/presentation/providers/provider_auth_provider.dart';
import 'package:nchito/features/provider/auth/presentation/screens/login/provider_login_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_identity/verify_identity_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_otp/provider_verify_otp_screen.dart';

class ProviderSignUpScreen extends StatefulWidget {
  static const String routeName = '/provider/signup';

  const ProviderSignUpScreen({super.key});

  @override
  State<ProviderSignUpScreen> createState() => _ProviderSignUpScreenState();
}

class _ProviderSignUpScreenState extends State<ProviderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccountPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreeToTerms) {
      AppSnackbar.showError(
        context,
        'Please agree to the Terms of Service & Privacy Policy',
      );
      return;
    }

    final identifier = _emailOrPhoneController.text.trim();
    final authProvider = context.read<ProviderAuthProvider>();
    final success = await authProvider.register(
      identifier: identifier,
      fullName: _fullNameController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      acceptTerms: _agreeToTerms,
    );

    if (!mounted) return;

    if (success) {
      AppSnackbar.showSuccess(
        context,
        authProvider.successMessage ?? 'Verification code sent to $identifier',
      );
      context.push(
        ProviderVerifyOtpScreen.routeName,
        extra: {
          'identifier': identifier,
          'nextRouteName': VerifyIdentityScreen.routeName,
        },
      );
    } else {
      AppSnackbar.showError(
        context,
        authProvider.errorMessage ?? 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProviderAuthProvider>().isLoading;

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
                        const AuthHeader(
                          title: 'Provider Sign Up',
                          subtitle:
                              'Create your account to offer services on Nchito',
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),

                        // Full Name
                        AppTextField(
                          label: AppText.fullName,
                          hint: AppText.enterYourFullName,
                          controller: _fullNameController,
                          validator: (value) => Validators.required(
                            value,
                            fieldName: AppText.fullName,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20)),

                        // Email or Phone Number
                        AppTextField(
                          label: AppText.emailOrPhoneNumber,
                          hint: AppText.enterYourEmailAddressOrMobileNumber,
                          controller: _emailOrPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validators.required(
                            value,
                            fieldName: AppText.emailOrPhoneNumber,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20)),

                        // Password
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
                        SizedBox(height: ResponsiveHelper.spacing(20)),

                        // Confirm Password
                        AppTextField(
                          label: AppText.confirmPassword,
                          hint: AppText.enterYourPassword,
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          validator: (value) => Validators.match(
                            value,
                            _passwordController.text,
                            message: 'Passwords do not match',
                          ),
                          suffixIcon: IconButton(
                            icon: AppIcon(
                              assetPath: AssetsPath.logInIconEyeToggle,
                              size: ResponsiveHelper.iconSize(16),
                              color: AppTheme.inputIconColor,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        // Terms
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => setState(
                                () => _agreeToTerms = !_agreeToTerms,
                              ),
                              child: SvgPicture.asset(
                                _agreeToTerms
                                    ? AssetsPath.logInIconCheckboxChecked
                                    : AssetsPath.logInIconCheckboxUnchecked,
                                width: ResponsiveHelper.iconSize(20),
                                height: ResponsiveHelper.iconSize(20),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(8)),
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${AppText.iAgreeToThe} ',
                                    style: context.bodyMedium,
                                  ),
                                  Text(
                                    AppText.termsOfService,
                                    style: context.bodyMedium.copyWith(
                                      color: AppColors.blueStatusInfo,
                                    ),
                                  ),
                                  Text(
                                    ' ${AppText.andConnector} ',
                                    style: context.bodyMedium,
                                  ),
                                  Text(
                                    AppText.privacyPolicy,
                                    style: context.bodyMedium.copyWith(
                                      color: AppColors.blueStatusInfo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        // Create Account button
                        ElevatedButton(
                          onPressed: isLoading ? null : _onCreateAccountPressed,
                          child: isLoading
                              ? SizedBox(
                                  width: ResponsiveHelper.iconSize(20),
                                  height: ResponsiveHelper.iconSize(20),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(AppText.createAccount),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        // Already have an account? Log In ?
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                AppText.alreadyHaveAnAccount,
                                style: context.displaySmall,
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(4)),
                              GestureDetector(
                                onTap: () => context.push(
                                  ProviderLoginScreen.routeName,
                                ),
                                child: Text(
                                  AppText.logInQuestion,
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
