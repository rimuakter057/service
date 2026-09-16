import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';

/// Filter option for earnings
class _EarningsFilterOption {
  final String label;
  final String cardTitle;
  final String cardSubtitle;
  final String amount;

  const _EarningsFilterOption({
    required this.label,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.amount,
  });
}

/// Payment history item model
class _PaymentHistoryItem {
  final String name;
  final String dateTime;
  final String amount;
  final String providerName;
  final String providerLogo;
  final String avatarAsset;

  const _PaymentHistoryItem({
    required this.name,
    required this.dateTime,
    required this.amount,
    required this.providerName,
    required this.providerLogo,
    required this.avatarAsset,
  });
}

/// Provider Earnings Screen — displays total earnings summary, time range filter,
/// and complete payment history with customer avatars and payment methods.
class ProviderEarningsScreen extends StatefulWidget {
  static const String routeName = '/provider/earnings';

  const ProviderEarningsScreen({super.key});

  @override
  State<ProviderEarningsScreen> createState() => _ProviderEarningsScreenState();
}

class _ProviderEarningsScreenState extends State<ProviderEarningsScreen> {
  static const List<_EarningsFilterOption> _filterOptions = [
    _EarningsFilterOption(
      label: 'All',
      cardTitle: 'Total Earnings',
      cardSubtitle: 'Showing All Earnings',
      amount: '\$ 160',
    ),
    _EarningsFilterOption(
      label: 'Last 24 Hours',
      cardTitle: 'Earnings for Today',
      cardSubtitle: 'Showing Earnings for Today',
      amount: '\$ 00',
    ),
    _EarningsFilterOption(
      label: 'Last Week',
      cardTitle: 'Earnings for Last Week',
      cardSubtitle: 'Showing Earnings for Last Week',
      amount: '\$ 64',
    ),
    _EarningsFilterOption(
      label: 'Last Fortnight',
      cardTitle: 'Earnings for Last Fortnight',
      cardSubtitle: 'Showing Earnings for Last Fortnight',
      amount: '\$ 96',
    ),
    _EarningsFilterOption(
      label: 'Last Month',
      cardTitle: 'Earnings for Last Month',
      cardSubtitle: 'Showing Earnings for Last Month',
      amount: '\$ 160',
    ),
    _EarningsFilterOption(
      label: 'Last Year',
      cardTitle: 'Earnings for Last Year',
      cardSubtitle: 'Showing Earnings for Last Year',
      amount: '\$ 1,920',
    ),
  ];

  late _EarningsFilterOption _selectedFilter;

  final List<_PaymentHistoryItem> _paymentList = const [
    _PaymentHistoryItem(
      name: 'Emily Carter',
      dateTime: 'Feb 9, 2026 • 8:30 PM',
      amount: 'ZMW32',
      providerName: 'Airtel Money',
      providerLogo: AssetsPath.connectPaymentsLogoAirtelMoney,
      avatarAsset: AssetsPath.messagesAvatarSophiaWhite,
    ),
    _PaymentHistoryItem(
      name: 'John Miller',
      dateTime: 'Feb 9, 2026 • 8:30 PM',
      amount: 'ZMW32',
      providerName: 'MTN MoMo',
      providerLogo: AssetsPath.connectPaymentsLogoMtnMoney,
      avatarAsset: AssetsPath.messagesAvatarDavidKim,
    ),
    _PaymentHistoryItem(
      name: 'Thomas Baker',
      dateTime: 'Feb 9, 2026 • 8:30 PM',
      amount: 'ZMW32',
      providerName: 'MTN MoMo',
      providerLogo: AssetsPath.connectPaymentsLogoMtnMoney,
      avatarAsset: AssetsPath.messagesAvatarMichaelSmith,
    ),
    _PaymentHistoryItem(
      name: 'Chris Brown',
      dateTime: 'Feb 9, 2026 • 8:30 PM',
      amount: 'ZMW32',
      providerName: 'Zamtel',
      providerLogo: AssetsPath.connectPaymentsLogoZamtelMoney,
      avatarAsset: AssetsPath.messagesAvatarRobertsJunior,
    ),
    _PaymentHistoryItem(
      name: 'Robert Davis',
      dateTime: 'Feb 9, 2026 • 8:30 PM',
      amount: 'ZMW32',
      providerName: 'Zamtel',
      providerLogo: AssetsPath.connectPaymentsLogoZamtelMoney,
      avatarAsset: AssetsPath.messagesAvatarOliviaMartinez,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Default to "Last 24 Hours" as shown in screenshot ("Earnings for Today" & "$ 00")
    _selectedFilter = _filterOptions[1];
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(24)),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(20),
            vertical: ResponsiveHelper.padding(16),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: ResponsiveHelper.width(40),
                    height: ResponsiveHelper.height(4),
                    margin: EdgeInsets.only(
                      bottom: ResponsiveHelper.spacing(16),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E7EC),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(2),
                      ),
                    ),
                  ),
                ),
                Text(
                  AppText.serviceType,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlackPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.height(12)),
                ..._filterOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = option.label == _selectedFilter.label;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFilter = option;
                          });
                          Navigator.pop(ctx);
                        },
                        splashColor: AppColors.brandSoft,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.padding(14),
                            horizontal: ResponsiveHelper.padding(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option.label,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(15),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.textBlackPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                width: ResponsiveHelper.width(22),
                                height: ResponsiveHelper.width(22),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF0F3E2E)
                                        : const Color(0xFFD0D5DD),
                                    width: isSelected ? 2 : 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: ResponsiveHelper.width(10),
                                          height: ResponsiveHelper.width(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF0F3E2E),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index < _filterOptions.length - 1)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF2F4F7),
                        ),
                    ],
                  );
                }),
                SizedBox(height: ResponsiveHelper.height(12)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.earnings,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                  vertical: ResponsiveHelper.padding(12),
                ),
                children: [
                  _buildEarningsCard(),
                  SizedBox(height: ResponsiveHelper.height(24)),
                  Text(
                    AppText.paymentHistory,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.height(12)),
                  ..._paymentList.map(_buildPaymentCard),
                  SizedBox(height: ResponsiveHelper.height(24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row inside card
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveHelper.padding(16),
              ResponsiveHelper.padding(14),
              ResponsiveHelper.padding(14),
              ResponsiveHelper.padding(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFilter.cardTitle,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlackPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Container(
                    width: ResponsiveHelper.width(36),
                    height: ResponsiveHelper.width(36),
                    decoration: BoxDecoration(
                      color: AppColors.brandSoft,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8),
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: ResponsiveHelper.iconSize(18),
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF4F6F8),
          ),
          // Earnings info row
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.width(46),
                  height: ResponsiveHelper.width(46),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EF),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(12),
                    ),
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    size: ResponsiveHelper.iconSize(22),
                    color: AppColors.brandPrimary,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.width(14)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFilter.cardSubtitle,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: ResponsiveHelper.fontSize(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.height(4)),
                    Text(
                      _selectedFilter.amount,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF0F3E2E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(_PaymentHistoryItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(10),
            ),
            child: Image.asset(
              item.avatarAsset,
              width: ResponsiveHelper.width(46),
              height: ResponsiveHelper.height(46),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: ResponsiveHelper.width(46),
                height: ResponsiveHelper.height(46),
                color: AppColors.brandSoft,
                child: Icon(
                  Icons.person,
                  color: AppColors.brandPrimary,
                  size: ResponsiveHelper.iconSize(24),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.width(12)),
          // Name and timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlackPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.height(3)),
                Text(
                  item.dateTime,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11.5),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount and provider method
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(14.5),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF0F3E2E),
                ),
              ),
              SizedBox(height: ResponsiveHelper.height(3)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Via • ',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Image.asset(
                    item.providerLogo,
                    height: ResponsiveHelper.height(13),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      item.providerName,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(10),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
