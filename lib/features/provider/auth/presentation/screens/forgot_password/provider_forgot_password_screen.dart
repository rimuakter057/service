import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/features/provider/auth/presentation/screens/forgot_password_verify_otp/provider_forgot_password_verify_otp_screen.dart';

class ProviderForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/provider/forgot-password';

  const ProviderForgotPasswordScreen({super.key});

  @override
  State<ProviderForgotPasswordScreen> createState() =>
      _ProviderForgotPasswordScreenState();
}

class _ProviderForgotPasswordScreenState
    extends State<ProviderForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: 'provider@nchito.com',
  );

  void _onSendVerificationCodePressed() {
    context.push(ProviderForgotPasswordVerifyOtpScreen.routeName);
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

                        AppTextField(
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
