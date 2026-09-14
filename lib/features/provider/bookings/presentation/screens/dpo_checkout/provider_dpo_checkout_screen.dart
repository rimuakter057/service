import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import '../booking_confirmed/provider_booking_confirmed_screen.dart';
import '../booking_details/provider_bookings_screen.dart';

class ProviderDpoCheckoutScreen extends StatefulWidget {
  static const String routeName = '/provider/bookings/dpo-checkout';

  final BookingHistoryData booking;

  const ProviderDpoCheckoutScreen({super.key, required this.booking});

  @override
  State<ProviderDpoCheckoutScreen> createState() =>
      _ProviderDpoCheckoutScreenState();
}

class _ProviderDpoCheckoutScreenState extends State<ProviderDpoCheckoutScreen> {
  int _currentStep = 1; // 1 = Personal Details, 2 = Choose Payment Method, 3 = Payment Successful
  int _paymentMethod = 0; // 0 = Card, 1 = Mobile

  // Step 1 Controllers
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final String _selectedCountryCode = '+260 (Zambia)';

  // Step 2 Card Controllers & State
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveDetails = false;
  bool _agreeTermsCard = true;

  // Step 2 Mobile State
  final String _selectedMobileCountry = 'Zambia';
  String? _selectedMobileProvider = 'Airtel Money';
  bool _agreeTermsMobile = true;

  // Timer countdown
  int _secondsRemaining = 56 * 60 + 41; // 56m 41s
  Timer? _timer;

  static const List<String> _mobileProviders = [
    'Airtel Money',
    'MTN MoMo',
    'Zamtel Kwacha',
    'Zanaco Bank',
    'FNB Zambia',
    'Stanchart Zambia',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String get _formattedTimer {
    final hours = (_secondsRemaining ~/ 3600);
    final minutes = (_secondsRemaining % 3600) ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '0d ${hours}h ${minutes}m ${seconds}s';
  }

  String get _totalCost =>
      widget.booking.serviceCost ?? widget.booking.price;

  void _onProceedPayment() {
    setState(() => _currentStep = 3);
  }

  void _handleBack() {
    if (_currentStep == 3) {
      context.go(ProviderBookingsScreen.routeName);
    } else if (_currentStep == 2) {
      setState(() => _currentStep = 1);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.dpoCheckOut,
              onBack: _handleBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                  vertical: ResponsiveHelper.padding(12),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDpoHeader(),
                          if (_currentStep != 3) ...[
                            _buildTimerBanner(),
                            SizedBox(height: ResponsiveHelper.spacing(16)),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStepDot(isActive: _currentStep == 1),
                                  SizedBox(width: ResponsiveHelper.spacing(4)),
                                  _buildStepDot(isActive: _currentStep == 2),
                                  SizedBox(width: ResponsiveHelper.spacing(4)),
                                  _buildStepDot(isActive: false),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(16)),
                            _buildServiceSummaryCard(),
                            if (_currentStep == 1) _buildStep1PersonalDetails(),
                            if (_currentStep == 2) _buildStep2PaymentMethod(),
                          ] else ...[
                            const Divider(
                              height: 1,
                              thickness: 0.8,
                              color: Color(0xFFF1F5F9),
                            ),
                            _buildStep3PaymentSuccess(),
                          ],
                        ],
                      ),
                    ),
                    if (_currentStep == 3) ...[
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveHelper.height(44),
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(
                              ProviderBookingConfirmedScreen.routeName,
                              extra: widget.booking,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                            ),
                          ),
                          child: Text(
                            AppText.ok,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDpoHeader() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppIcon(
                assetPath: AssetsPath.myBookingsDpo,
                size: ResponsiveHelper.iconSize(28),
              ),
              SizedBox(width: ResponsiveHelper.spacing(8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'DPO',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: ResponsiveHelper.fontSize(14),
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(4)),
                      Text(
                        'GROUP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(10),
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppText.thinkPayments,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(9),
                      color: const Color(0xFF0057B7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(16),
              vertical: ResponsiveHelper.padding(6),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0057B7),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(6),
              ),
            ),
            child: Text(
              AppText.login,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(12),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
        vertical: ResponsiveHelper.padding(8),
      ),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 14,
            color: Color(0xFF0057B7),
          ),
          SizedBox(width: ResponsiveHelper.spacing(6)),
          Text(
            AppText.completePaymentWithin,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(11),
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(4)),
          Text(
            _formattedTimer,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(11),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0057B7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot({required bool isActive}) {
    return Container(
      width: isActive ? ResponsiveHelper.width(20) : ResponsiveHelper.width(6),
      height: ResponsiveHelper.height(4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0057B7) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildServiceSummaryCard() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.width(36),
              height: ResponsiveHelper.width(36),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDBEAFE),
              ),
              child: Center(
                child: AppIcon(
                  assetPath: AssetsPath.myBookingsElectricalRepair,
                  size: ResponsiveHelper.iconSize(18),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.booking.service,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveHelper.fontSize(13),
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(
                    'Provider: ${widget.booking.providerName}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11),
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _totalCost,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveHelper.fontSize(13),
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1PersonalDetails() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.paymentReference,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(9),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(
                    'NCH-2026-008472',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppText.serviceDate,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(9),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(
                    widget.booking.date,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.totalUpper,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                _totalCost,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0057B7),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(20)),

          Row(
            children: [
              const Icon(
                Icons.radio_button_checked,
                size: 16,
                color: Color(0xFF0057B7),
              ),
              SizedBox(width: ResponsiveHelper.spacing(6)),
              Text(
                AppText.personalDetails,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),

          _buildDpoInput(
            controller: _firstNameController,
            hint: AppText.firstName,
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),
          _buildDpoInput(
            controller: _lastNameController,
            hint: AppText.lastName,
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),
          _buildDpoInput(
            controller: _emailController,
            hint: AppText.emailAddress,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),

          Container(
            height: ResponsiveHelper.height(44),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(14),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCountryCode,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(20)),

          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.height(44),
            child: ElevatedButton(
              onPressed: () {
                setState(() => _currentStep = 2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0057B7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.continueToPayment,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(13),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(6)),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),

          Center(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.padding(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      AppText.backLink,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(11),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
        ],
      ),
    );
  }

  Widget _buildStep2PaymentMethod() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.radio_button_checked,
                size: 16,
                color: Color(0xFF0057B7),
              ),
              SizedBox(width: ResponsiveHelper.spacing(6)),
              Text(
                AppText.choosePaymentMethod,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(14)),

          Row(
            children: [
              Expanded(
                child: _buildPaymentTab(
                  index: 0,
                  label: AppText.card,
                  iconAsset: AssetsPath.myBookingsCard,
                ),
              ),
              Expanded(
                child: _buildPaymentTab(
                  index: 1,
                  label: AppText.mobile,
                  iconAsset: AssetsPath.myBookingsMobile,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          if (_paymentMethod == 0) _buildCardForm(),
          if (_paymentMethod == 1) _buildMobileForm(),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          Center(
            child: GestureDetector(
              onTap: () => setState(() => _currentStep = 1),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.padding(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      AppText.backToDetails,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(11),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
        ],
      ),
    );
  }

  Widget _buildPaymentTab({
    required int index,
    required String label,
    required String iconAsset,
  }) {
    final isSelected = _paymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(10)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF0057B7) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          children: [
            AppIcon(
              assetPath: iconAsset,
              size: ResponsiveHelper.iconSize(20),
              color: isSelected ? const Color(0xFF0057B7) : const Color(0xFF94A3B8),
            ),
            SizedBox(height: ResponsiveHelper.spacing(4)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(12),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0057B7) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDpoInput(
          controller: _cardHolderController,
          hint: AppText.cardHolderName,
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),
        _buildDpoInput(
          controller: _cardNumberController,
          hint: AppText.cardNumber,
          keyboardType: TextInputType.number,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCardBrandBadge('VISA', const Color(0xFF1A1F71)),
              SizedBox(width: ResponsiveHelper.spacing(4)),
              _buildMastercardBadge(),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),
        Row(
          children: [
            Expanded(
              child: _buildDpoInput(
                controller: _expiryController,
                hint: AppText.mmYy,
                keyboardType: TextInputType.datetime,
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(10)),
            Expanded(
              child: _buildDpoInput(
                controller: _cvvController,
                hint: AppText.securityCodeCvv,
                keyboardType: TextInputType.number,
                suffix: const Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(12)),

        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _saveDetails,
                onChanged: (val) => setState(() => _saveDetails = val ?? false),
                activeColor: const Color(0xFF0057B7),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Expanded(
              child: Text(
                AppText.saveAllMyDetailsForFuturePayments,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(11),
                  color: const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _agreeTermsCard,
                onChanged: (val) =>
                    setState(() => _agreeTermsCard = val ?? false),
                activeColor: const Color(0xFF0057B7),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '${AppText.iAgreeToDpos} ',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    color: const Color(0xFF475569),
                  ),
                  children: [
                    TextSpan(
                      text: AppText.termsAndConditions,
                      style: const TextStyle(
                        color: Color(0xFF0057B7),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(18)),

        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.height(44),
          child: ElevatedButton(
            onPressed: _agreeTermsCard ? _onProceedPayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0057B7),
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: _agreeTermsCard ? Colors.white : const Color(0xFF94A3B8),
                ),
                SizedBox(width: ResponsiveHelper.spacing(6)),
                Text(
                  '${AppText.pay} $_totalCost',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: _agreeTermsCard ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: ResponsiveHelper.height(44),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(14),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(8),
            ),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedMobileCountry,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12),
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(12)),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mobileProviders.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: ResponsiveHelper.spacing(8),
            crossAxisSpacing: ResponsiveHelper.spacing(8),
            childAspectRatio: 2.8,
          ),
          itemBuilder: (context, index) {
            final provider = _mobileProviders[index];
            final isSelected = _selectedMobileProvider == provider;
            return GestureDetector(
              onTap: () => setState(() => _selectedMobileProvider = provider),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0057B7) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  provider,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? const Color(0xFF0057B7) : const Color(0xFF334155),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: ResponsiveHelper.spacing(12)),

        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _agreeTermsMobile,
                onChanged: (val) =>
                    setState(() => _agreeTermsMobile = val ?? false),
                activeColor: const Color(0xFF0057B7),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '${AppText.iAgreeToDpos} ',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    color: const Color(0xFF475569),
                  ),
                  children: [
                    TextSpan(
                      text: AppText.termsAndConditions,
                      style: const TextStyle(
                        color: Color(0xFF0057B7),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(18)),

        SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.height(44),
          child: ElevatedButton(
            onPressed: _agreeTermsMobile ? _onProceedPayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0057B7),
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: _agreeTermsMobile ? Colors.white : const Color(0xFF94A3B8),
                ),
                SizedBox(width: ResponsiveHelper.spacing(6)),
                Text(
                  AppText.payViaMobile,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: _agreeTermsMobile ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3PaymentSuccess() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),
        vertical: ResponsiveHelper.padding(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: ResponsiveHelper.spacing(8)),

          Center(
            child: AppIcon(
              assetPath: AssetsPath.myBookingsSuccessPayment,
              size: ResponsiveHelper.iconSize(84),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          Text(
            'Payment Successful!',
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(19),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(6)),

          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(12),
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Your payment of '),
                TextSpan(
                  text: _totalCost,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const TextSpan(text: ' for\n'),
                TextSpan(
                  text: widget.booking.service,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const TextSpan(text: ' has been processed.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.spacing(20)),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RECEIPT',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(10),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(12)),
                _buildReceiptRow('Service', widget.booking.service),
                SizedBox(height: ResponsiveHelper.spacing(10)),
                _buildReceiptRow('Provider', widget.booking.providerName),
                SizedBox(height: ResponsiveHelper.spacing(10)),
                _buildReceiptRow('Reference', 'NCH-2026-008472'),
                SizedBox(height: ResponsiveHelper.spacing(10)),
                _buildReceiptRow(
                  'Amount',
                  _totalCost,
                  valueColor: const Color(0xFF0057B7),
                ),
                SizedBox(height: ResponsiveHelper.spacing(10)),
                _buildReceiptRow(
                  'Status',
                  'Completed',
                  valueColor: const Color(0xFF10B981),
                ),
                SizedBox(height: ResponsiveHelper.spacing(10)),
                _buildReceiptRow('Date', widget.booking.date),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(24)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 14,
                color: Color(0xFF0057B7),
              ),
              SizedBox(width: ResponsiveHelper.spacing(6)),
              Text(
                'Secured by DPO GROUP · Think Payments',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(10),
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(12),
            color: const Color(0xFF94A3B8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(12),
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildDpoInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Container(
      height: ResponsiveHelper.height(44),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(12),
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12),
                  color: const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget _buildCardBrandBadge(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMastercardBadge() {
    return SizedBox(
      width: 22,
      height: 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
