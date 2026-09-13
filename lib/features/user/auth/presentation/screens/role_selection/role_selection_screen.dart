import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/constants/user_role.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  static const String routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  void _onContinuePressed() {
    final role = _selectedRole;
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please choose how you'd like to use Nchito"),
        ),
      );
      return;
    }
    context.push(SignUpScreen.routeName, extra: role);
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
                      AuthHeader(
                        title: AppText.howWouldYouLikeToUseNchito,
                        subtitle: AppText
                            .chooseHowYoudLikeToUseNchitoFindTheHelpYouNeedOrOfferYourSkillsToOthers,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(32)),

                      Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              illustration: AssetsPath
                                  .splashScreenIllustrationFindService,
                              label: AppText.findAService,
                              selected: _selectedRole == UserRole.user,
                              onTap: () => setState(
                                () => _selectedRole = UserRole.user,
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(16)),
                          Expanded(
                            child: _RoleCard(
                              illustration: AssetsPath
                                  .splashScreenIllustrationOfferService,
                              label: AppText.offerAService,
                              selected: _selectedRole == UserRole.provider,
                              onTap: () => setState(
                                () => _selectedRole = UserRole.provider,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(32)),

                      ElevatedButton(
                        onPressed: _onContinuePressed,
                        child: Text(AppText.continueButton),
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

class _RoleCard extends StatelessWidget {
  final String illustration;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.illustration,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: selected ? AppColors.brandSoft : AppColors.bgCard,
        border: Border.all(
          color: selected ? AppColors.brandPrimary : AppColors.borderDefault,
          width: selected ? 2 : 1,
        ),
        child: Column(
          children: [
            AppIcon(assetPath: illustration, size: ResponsiveHelper.width(64)),
            SizedBox(height: ResponsiveHelper.spacing(12)),
            Text(label, textAlign: TextAlign.center, style: context.labelLarge),
          ],
        ),
      ),
    );
  }
}
