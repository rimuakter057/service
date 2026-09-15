import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Modal bottom sheet for provider to enter/verify customer OTP to complete service (Image 3)
class ConfirmServiceCompletionBottomSheet extends StatefulWidget {
  final VoidCallback onVerifyOtp;

  const ConfirmServiceCompletionBottomSheet({
    super.key,
    required this.onVerifyOtp,
  });

  @override
  State<ConfirmServiceCompletionBottomSheet> createState() =>
      _ConfirmServiceCompletionBottomSheetState();
}

class _ConfirmServiceCompletionBottomSheetState
    extends State<ConfirmServiceCompletionBottomSheet> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Default sample OTP
    const defaultOtp = '482731';
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = defaultOtp[i];
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    Navigator.of(context).pop();
    widget.onVerifyOtp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(20),
            vertical: ResponsiveHelper.padding(20),
          ),
          decoration: BoxDecoration(
            color: AppColors.bgApp,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(24)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.confirmServiceCompletion,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(17),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: ResponsiveHelper.width(28),
                      height: ResponsiveHelper.width(28),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(6)),

              // Subtitle
              Text(
                AppText
                    .askTheCustomerToEnterTheOtpToConfirmThatTheServiceHasBeenCompleted,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(11.5),
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(18)),

              // Customer OTP label
              Text(
                AppText.customerOtp,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),

              // 6 OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Container(
                    width: ResponsiveHelper.width(46),
                    height: ResponsiveHelper.height(46),
                    decoration: BoxDecoration(
                      color: AppColors.bgOverlay.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(10),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: ResponsiveHelper.spacing(22)),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppText.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppColors.bgOverlay.withValues(
                        alpha: 0.04,
                      ),
                      borderColor: const Color(0xFFE2E8F0),
                      textColor: const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: AppButton(
                      text: AppText.verifyOtp,
                      onPressed: _onVerify,
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),
            ],
          ),
        ),
      ),
    );
  }
}
