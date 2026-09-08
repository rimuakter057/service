import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/auth/presentation/screens/role_selection/role_selection_screen.dart';

class AgeConfirmationScreen extends StatelessWidget {
  static const String routeName = '/age-confirmation';

  const AgeConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(24),
            ),
            child: AppContainerBg(
              radius: ResponsiveHelper.borderRadius(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BgIcon(
                    assetPath: AssetsPath.ageConfirmationAlertIconInformation,
                    bgColor: AppColors.orange50,
                    iconColor: AppColors.orange400,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(16)),
                  Text(
                    AppText.ageConfirmation,
                    textAlign: TextAlign.center,
                    style: context.titleLarge.copyWith(
                      fontSize: ResponsiveHelper.fontSize(20),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(8)),
                  Text.rich(
                    _buildBodyTextSpan(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(26)),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: AppText.exit,
                          onPressed: () => SystemNavigator.pop(),
                          borderColor: Colors.red,
                          textColor: Colors.red,
                          radius: ResponsiveHelper.borderRadius(8),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(12)),
                      Expanded(
                        child: AppButton(
                          text: AppText.enter21Plus,
                          onPressed: () =>
                              context.push(RoleSelectionScreen.routeName),
                          backgroundColor: AppColors.brandPrimary,
                          textColor: AppColors.textOnPrimary,
                          radius: ResponsiveHelper.borderRadius(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildBodyTextSpan(BuildContext context) {
    const highlight = '21+';
    final body = AppText
        .youMustBe18YearsOrOlderToCreateAnAccountAndUseNchitoServicesPleaseConfirmYourAgeToContinue;
    final parts = body.split(highlight);
    final baseStyle = context.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    );

    if (parts.length != 2) {
      return TextSpan(text: body, style: baseStyle);
    }

    return TextSpan(
      style: baseStyle,
      children: [
        TextSpan(text: parts[0]),
        TextSpan(
          text: highlight,
          style: TextStyle(
            color: AppColors.blueStatusInfo,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(text: parts[1]),
      ],
    );
  }
}
