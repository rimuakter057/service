import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

class _NetworkOption {
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final String name;
  final String series;

  const _NetworkOption({
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.name,
    required this.series,
  });
}

/// DPO-branded "Link Payment Account" screen — lets the user pick a
/// mobile money network to verify ownership of via SMS OTP. Part of the
/// provider auth/payments flow alongside [ConnectPaymentsScreen] and
/// [VerifyIdentityScreen]. Mirrors the DPO Checkout widget's own styling
/// (hardcoded colors, not the app's design tokens) since it represents an
/// embedded third-party page.
///
/// Not yet wired into a specific navigation trigger — route is registered
/// and ready.
class LinkPaymentAccountScreen extends StatelessWidget {
  static const String routeName = '/link-payment-account';

  const LinkPaymentAccountScreen({super.key});

  static const List<_NetworkOption> _networks = [
    _NetworkOption(
      badgeLabel: 'A',
      badgeColor: Color(0xFFE20014),
      badgeTextColor: Colors.white,
      name: AppText.airtelMoney,
      series: AppText.airtelMoneySeries,
    ),
    _NetworkOption(
      badgeLabel: 'M',
      badgeColor: Color(0xFFFFCC00),
      badgeTextColor: Color(0xFF1A1A1A),
      name: AppText.mtnMomo,
      series: AppText.mtnMomoSeries,
    ),
    _NetworkOption(
      badgeLabel: 'Z',
      badgeColor: Color(0xFF085E19),
      badgeTextColor: Colors.white,
      name: AppText.zamtelKwacha,
      series: AppText.zamtelKwachaSeries,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                  vertical: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.connectYourMobileMoneyAccount,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF14212B),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      AppText
                          .payoutsGoOnlyToAVerifiedAccountWeSendA6DigitSmsToConfirmYouOwnTheNumber,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        color: const Color(0xFF888888),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    _buildPinNoticeBanner(),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    Text(
                      AppText.selectYourNetwork,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: const Color(0xFFC0C8D0),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    for (final network in _networks) ...[
                      _NetworkTile(network: network),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          AppIcon(
            assetPath: AssetsPath.myBookingsDpo,
            size: ResponsiveHelper.iconSize(40),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
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
                      size: ResponsiveHelper.iconSize(9),
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
                          fontSize: ResponsiveHelper.fontSize(14),
                          color: const Color(0xFFDDDDDD),
                        ),
                      ),
                    ),
                    Text(
                      AppText.secured,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(10),
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.shield_outlined,
            size: ResponsiveHelper.iconSize(15),
            color: const Color(0xFF0057B7),
          ),
        ],
      ),
    );
  }

  Widget _buildPinNoticeBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
        vertical: ResponsiveHelper.padding(14),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        border: Border.all(color: const Color(0xFFCFE3FF)),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: ResponsiveHelper.iconSize(15),
            color: const Color(0xFF0057B7),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.yourWalletPinIsNeverCollected,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14212B),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(2)),
                Text(
                  AppText.weOnlyVerifyNumberOwnershipViaSmsOtpNoPinNoPasswordEver,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    color: const Color(0xFF6A7D8E),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(20)),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            assetPath: AssetsPath.myBookingsDpo,
            size: ResponsiveHelper.iconSize(9),
          ),
          SizedBox(width: ResponsiveHelper.spacing(6)),
          Text(
            AppText.poweredByDpoGroupThinkPayments,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(11),
              color: const Color(0xFFC0C8D0),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkTile extends StatelessWidget {
  final _NetworkOption network;

  const _NetworkTile({required this.network});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.width(46),
            height: ResponsiveHelper.width(46),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: network.badgeColor,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(14),
              ),
            ),
            child: Text(
              network.badgeLabel,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(13),
                fontWeight: FontWeight.w900,
                color: network.badgeTextColor,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  network.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14212B),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(2)),
                Text(
                  network.series,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: ResponsiveHelper.iconSize(16),
            color: const Color(0xFF14212B),
          ),
        ],
      ),
    );
  }
}
