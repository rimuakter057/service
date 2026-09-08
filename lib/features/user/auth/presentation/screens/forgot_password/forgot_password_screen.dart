import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/features/user/auth/presentation/screens/set_new_password/set_new_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/verify_otp/verify_otp_screen.dart';
import 'package:nchito/features/user/auth/presentation/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _onSendVerificationCodePressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO: wire up "send verification code" usecase
    context.push(
      VerifyOtpScreen.routeName,
      extra: {
        'subtitle':
            AppText.enterThe6DigitVerificationCodeSentToYourMobileNumber,
        'nextRouteName': SetNewPasswordScreen.routeName,
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                        AuthHeader(
                          title: AppText.forgotPasswordTitle,
                          subtitle: AppText
                              .enterYourRegisteredEmailAddressAndWellSendYouAVerificationCodeToResetYourPassword,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),

                        AuthTextField(
                          label: AppText.emailAddress,
                          hint: AppText.enterYourRegisteredEmailAddress,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        ElevatedButton(
                          onPressed: _onSendVerificationCodePressed,
                          child: Text(AppText.sendVerificationCode),
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
