import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/provider/auth/presentation/providers/provider_auth_provider.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_identity/verify_identity_screen.dart';

class ProviderVerifyOtpScreen extends StatefulWidget {
  static const String routeName = '/provider/verify-otp';

  final String identifier;
  final String subtitle;
  final String nextRouteName;

  const ProviderVerifyOtpScreen({
    super.key,
    required this.identifier,
    this.subtitle =
        AppText.enterThe6DigitVerificationCodeSentToYourEmailAddress,
    this.nextRouteName = VerifyIdentityScreen.routeName,
  });

  @override
  State<ProviderVerifyOtpScreen> createState() =>
      _ProviderVerifyOtpScreenState();
}

class _ProviderVerifyOtpScreenState extends State<ProviderVerifyOtpScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 30;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  Timer? _resendTimer;
  int _secondsRemaining = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _secondsRemaining = _resendSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  String get _formattedCountdown {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _onResendPressed() async {
    if (_secondsRemaining > 0) return;
    final authProvider = context.read<ProviderAuthProvider>();
    final success = await authProvider.requestPasswordResetOtp(
      identifier: widget.identifier,
    );
    if (!mounted) return;
    if (success) {
      AppSnackbar.showSuccess(
        context,
        authProvider.successMessage ?? 'Verification code resent.',
      );
      _startResendTimer();
    } else {
      AppSnackbar.showError(
        context,
        authProvider.errorMessage ?? 'Failed to resend code.',
      );
    }
  }

  Future<void> _onVerifyPressed() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != _otpLength) {
      AppSnackbar.showError(context, 'Please enter the full 6-digit code');
      return;
    }

    final authProvider = context.read<ProviderAuthProvider>();
    final success = await authProvider.verifyRegistrationOtp(
      identifier: widget.identifier,
      code: code,
    );

    if (!mounted) return;

    if (success) {
      AppSnackbar.showSuccess(
        context,
        authProvider.successMessage ?? 'Account verified successfully!',
      );
      final targetRoute = widget.nextRouteName.isNotEmpty
          ? widget.nextRouteName
          : VerifyIdentityScreen.routeName;
      context.go(targetRoute);
    } else {
      AppSnackbar.showError(
        context,
        authProvider.errorMessage ?? 'Invalid code. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthHeader(
                        title: AppText.verifyYourOtp,
                        subtitle: widget.subtitle,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(32)),

                      Text(AppText.verificationCode, style: context.labelLarge),
                      SizedBox(height: ResponsiveHelper.spacing(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_otpLength, (index) {
                          return SizedBox(
                            width: ResponsiveHelper.width(48),
                            height: ResponsiveHelper.height(48),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: context.titleMedium.copyWith(
                                color: AppColors.textGrey,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) =>
                                  _onDigitChanged(index, value),
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                hintText: '•',
                                hintStyle: context.titleMedium.copyWith(
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppText.didntReceiveTheCode,
                            style: context.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: _secondsRemaining == 0
                                ? _onResendPressed
                                : null,
                            child: Text(
                              _secondsRemaining == 0
                                  ? AppText.resendAgain
                                  : '${AppText.resendIn} $_formattedCountdown',
                              style: context.bodyMedium.copyWith(
                                color: AppColors.blueStatusInfo,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      ElevatedButton(
                        onPressed: isLoading ? null : _onVerifyPressed,
                        child: isLoading
                            ? SizedBox(
                                width: ResponsiveHelper.iconSize(20),
                                height: ResponsiveHelper.iconSize(20),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(AppText.verifyCode),
                      ),
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
