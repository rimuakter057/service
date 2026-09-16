import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

class _NetworkItem {
  final String letter;
  final Color badgeBg;
  final Color letterColor;
  final String title;
  final String subtitle;

  const _NetworkItem({
    required this.letter,
    required this.badgeBg,
    required this.letterColor,
    required this.title,
    required this.subtitle,
  });
}

/// Brand-new dedicated Provider Linked Payment Account screen matching the design.
class ProviderLinkedPaymentAccountScreen extends StatelessWidget {
  static const String routeName = '/provider/linked-payment-account';

  const ProviderLinkedPaymentAccountScreen({super.key});

  static const List<_NetworkItem> _networks = [
    _NetworkItem(
      letter: 'A',
      badgeBg: Color(0xFFE20014),
      letterColor: Colors.white,
      title: 'Airtel Money',
      subtitle: '097 · 099 series',
    ),
    _NetworkItem(
      letter: 'M',
      badgeBg: Color(0xFFFFCC00),
      letterColor: Color(0xFF14212B),
      title: 'MTN MoMo',
      subtitle: '096 · 076 series',
    ),
    _NetworkItem(
      letter: 'Z',
      badgeBg: Color(0xFF085E19),
      letterColor: Colors.white,
      title: 'Zamtel Kwacha',
      subtitle: '095 series',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.connectYourMobileMoneyAccount,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(22),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF14212B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      AppText
                          .payoutsGoOnlyToAVerifiedAccountWeSendA6DigitSmsToConfirmYouOwnTheNumber,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        color: const Color(0xFF7A869A),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Pin notice banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        border: Border.all(color: const Color(0xFFCFE3FF)),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(14),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: ResponsiveHelper.iconSize(18),
                            color: const Color(0xFF0057B7),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.yourWalletPinIsNeverCollected,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(13),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF14212B),
                                  ),
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(4)),
                                Text(
                                  AppText
                                      .weOnlyVerifyNumberOwnershipViaSmsOtpNoPinNoPasswordEver,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(11),
                                    color: const Color(0xFF5A6E82),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    Text(
                      AppText.selectYourNetwork,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(11),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: const Color(0xFFA0AEC0),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    for (final item in _networks) ...[
                      _buildNetworkTile(context, item),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                    ],
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
        vertical: ResponsiveHelper.padding(14),
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEDF2F7))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: ResponsiveHelper.iconSize(20),
              color: const Color(0xFF14212B),
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: ResponsiveHelper.spacing(10)),
          AppIcon(
            assetPath: AssetsPath.myBookingsDpo,
            size: ResponsiveHelper.iconSize(36),
          ),
          SizedBox(width: ResponsiveHelper.spacing(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.linkPaymentAccount,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(15),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14212B),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(2)),
                Row(
                  children: [
                    AppIcon(
                      assetPath: AssetsPath.myBookingsDpo,
                      size: ResponsiveHelper.iconSize(10),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      AppText.dpoGroup,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(10),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0057B7),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(4),
                      ),
                      child: Text(
                        '·',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12),
                          color: const Color(0xFFCBD5E0),
                        ),
                      ),
                    ),
                    Text(
                      AppText.secured,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(10),
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.shield_outlined,
            size: ResponsiveHelper.iconSize(18),
            color: const Color(0xFF0057B7),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkTile(BuildContext context, _NetworkItem item) {
    return InkWell(
      onTap: () {
        // Handle selection of payment network
      },
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEDF2F7)),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.width(44),
              height: ResponsiveHelper.width(44),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.badgeBg,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(12),
                ),
              ),
              child: Text(
                item.letter,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.w900,
                  color: item.letterColor,
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF14212B),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      color: const Color(0xFFA0AEC0),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: ResponsiveHelper.iconSize(18),
              color: const Color(0xFFCBD5E0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            assetPath: AssetsPath.myBookingsDpo,
            size: ResponsiveHelper.iconSize(12),
          ),
          SizedBox(width: ResponsiveHelper.spacing(6)),
          Text(
            AppText.poweredByDpoGroupThinkPayments,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(10),
              color: const Color(0xFFA0AEC0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
