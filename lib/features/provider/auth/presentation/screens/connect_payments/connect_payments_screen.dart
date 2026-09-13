import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';

class _PaymentMethod {
  final String logoAsset;
  final String phoneNumber;
  bool isConnected;

  _PaymentMethod({
    required this.logoAsset,
    required this.phoneNumber,
    this.isConnected = false,
  });
}

/// Final step of the provider sign up flow — connect a mobile money
/// account to receive earnings. Reached after [VerifyIdentityScreen].
class ConnectPaymentsScreen extends StatefulWidget {
  static const String routeName = '/connect-payments';

  const ConnectPaymentsScreen({super.key});

  @override
  State<ConnectPaymentsScreen> createState() => _ConnectPaymentsScreenState();
}

class _ConnectPaymentsScreenState extends State<ConnectPaymentsScreen> {
  final List<_PaymentMethod> _methods = [
    _PaymentMethod(
      logoAsset: AssetsPath.connectPaymentsLogoAirtelMoney,
      phoneNumber: '+260 097 123 4567',
      isConnected: true,
    ),
    _PaymentMethod(
      logoAsset: AssetsPath.connectPaymentsLogoMtnMoney,
      phoneNumber: '+260 097 987 6543',
    ),
    _PaymentMethod(
      logoAsset: AssetsPath.connectPaymentsLogoZamtelMoney,
      phoneNumber: '+260 095 456 7890',
    ),
  ];

  bool get _hasConnectedMethod => _methods.any((m) => m.isConnected);

  void _toggleConnected(int index) {
    setState(() => _methods[index].isConnected = !_methods[index].isConnected);
  }

  void _onSaveAndContinue() {
    if (!_hasConnectedMethod) return;
    // TODO: wire up payment-connection usecase
    context.go(ProviderHomeScreen.routeName);
  }

  void _onSkip() {
    context.go(ProviderHomeScreen.routeName);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ResponsiveHelper.width(64),
                        height: ResponsiveHelper.width(64),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(15),
                          ),
                        ),
                        child: Text(
                          'ZMW',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(16),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                      Text(
                        AppText.connectPayments,
                        style: context.headlineSmall.copyWith(
                          fontSize: ResponsiveHelper.fontSize(28),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                      Text(
                        AppText
                            .connectYourMobileMoneyAccountToReceiveYourNchitoEarningsSecurely,
                        style: context.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      for (var i = 0; i < _methods.length; i++) ...[
                        _PaymentMethodRow(
                          method: _methods[i],
                          onTap: () => _toggleConnected(i),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                      ],
                      SizedBox(height: ResponsiveHelper.spacing(14)),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                        decoration: BoxDecoration(
                          color: AppColors.bgOverlay.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ResponsiveHelper.width(20),
                              height: ResponsiveHelper.width(20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.bgOverlay.withValues(
                                  alpha: 0.04,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(4),
                                ),
                              ),
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: ResponsiveHelper.iconSize(14),
                                color: AppColors.textBlackPrimary,
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(8)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppText.aboutNchitoPayments,
                                    style: context.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlackPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveHelper.spacing(6),
                                  ),
                                  Text(
                                    AppText
                                        .yourNchitoEarningsWillBeTransferredToYourConnectedMobileMoneyAccountAfterEligibleBookingsAreCompleted,
                                    style: context.bodySmall.copyWith(
                                      fontSize: ResponsiveHelper.fontSize(12),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      GestureDetector(
                        onTap: _hasConnectedMethod ? _onSaveAndContinue : null,
                        child: Container(
                          width: double.infinity,
                          height: ResponsiveHelper.buttonHeight(44),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _hasConnectedMethod
                                ? AppColors.brandPrimary
                                : AppColors.textBlackPrimary.withValues(
                                    alpha: 0.3,
                                  ),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),
                            ),
                          ),
                          child: Text(
                            AppText.saveAndContinue,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w600,
                              color: _hasConnectedMethod
                                  ? AppColors.white
                                  : AppColors.brandPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),

                      GestureDetector(
                        onTap: _onSkip,
                        child: Container(
                          width: double.infinity,
                          height: ResponsiveHelper.buttonHeight(44),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.bgOverlay.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppText.skipForNow,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(14),
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(10)),
                              AppIcon(
                                assetPath:
                                    AssetsPath.connectPaymentsIconSkipArrow,
                                size: ResponsiveHelper.iconSize(16),
                              ),
                            ],
                          ),
                        ),
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

class _PaymentMethodRow extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onTap;

  const _PaymentMethodRow({required this.method, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.width(40),
            height: ResponsiveHelper.width(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(10),
              ),
            ),
            child: AppIcon(
              assetPath: AssetsPath.connectPaymentsIconBank,
              size: ResponsiveHelper.iconSize(20),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  method.logoAsset,
                  height: ResponsiveHelper.height(20),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(
                      assetPath: AssetsPath.connectPaymentsIconLink,
                      size: ResponsiveHelper.iconSize(12),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      method.phoneNumber,
                      style: context.bodySmall.copyWith(
                        fontSize: ResponsiveHelper.fontSize(10),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(10)),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(14),
                vertical: ResponsiveHelper.padding(8),
              ),
              decoration: BoxDecoration(
                color: method.isConnected
                    ? AppColors.brandSoft
                    : AppColors.bgOverlay.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    assetPath: method.isConnected
                        ? AssetsPath.connectPaymentsIconConnected
                        : AssetsPath.connectPaymentsIconConnect,
                    size: ResponsiveHelper.iconSize(13),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(6)),
                  Text(
                    method.isConnected ? AppText.connected : AppText.connect,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      fontWeight: FontWeight.w600,
                      color: method.isConnected
                          ? AppColors.statusSuccess
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
