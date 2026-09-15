import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Bottom sheet shown when a provider taps "Accept" to input a final service price
/// before sending the quote to the customer.
class SendQuoteBottomSheet extends StatefulWidget {
  final ValueChanged<String> onSendQuote;

  const SendQuoteBottomSheet({super.key, required this.onSendQuote});

  @override
  State<SendQuoteBottomSheet> createState() => _SendQuoteBottomSheetState();
}

class _SendQuoteBottomSheetState extends State<SendQuoteBottomSheet> {
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final price = _priceController.text.trim();
    if (price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter final service price'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    widget.onSendQuote(price);
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
              // Header with Title and Close Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.sendQuote,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(18),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveHelper.padding(4)),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(18)),

              // Label
              Text(
                AppText.finalServicePrice,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),

              // Text field
              Container(
                height: ResponsiveHelper.height(48),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgOverlay.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: AppText.enterFinalPrice,
                    hintStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(13),
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(22)),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppText.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppColors.bgOverlay.withValues(
                        alpha: 0.04,
                      ),
                      borderColor: AppColors.textDisabled,
                      textColor: AppColors.textDisabled,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: AppButton(
                      text: AppText.sendQuote,
                      onPressed: _handleSubmit,
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
