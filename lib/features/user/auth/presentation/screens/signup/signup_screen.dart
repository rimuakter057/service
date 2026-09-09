import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/verify_otp/verify_otp_screen.dart';
import 'package:nchito/core/common_widgets/app_text_field/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  // TODO: remove test-only default values before release
  final TextEditingController _fullNameController = TextEditingController(
    text: 'Test User',
  );
  final TextEditingController _emailOrPhoneController = TextEditingController(
    text: 'test@nchito.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'test1234',
  );
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: 'test1234');

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = true; // TODO: default to false before release

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccountPressed() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy',
          ),
        ),
      );
      return;
    }

    // TODO: wire up signup usecase
    context.push(VerifyOtpScreen.routeName);
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
                        AuthHeader(
                          title: AppText.createYourAccount,
                          subtitle: AppText.signUpToGetStartedWithNchito,
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

                        /// I agree to the Terms of Service and Privacy Policy
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

                        ///======================== Create Account button
                        ElevatedButton(
                          onPressed: _onCreateAccountPressed,
                          child: Text(AppText.createAccount),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        ///==================== Already have an account? Log In ?
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                AppText.alreadyHaveAnAccount,
                                style: context.displaySmall,
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(4)),
                              GestureDetector(
                                onTap: () =>
                                    context.push(LoginScreen.routeName),
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
