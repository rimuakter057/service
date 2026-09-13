import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/features/user/profile/presentation/widgets/change_password_bottom_sheet.dart';

/// Lets the user change their account password. Navigated to from
/// [AccountSettingsScreen]'s "Change Password" menu tile.
class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Widget _eyeToggle(bool obscured, VoidCallback onPressed) {
    return IconButton(
      icon: AppIcon(
        assetPath: AssetsPath.logInIconEyeToggle,
        size: ResponsiveHelper.iconSize(16),
        color: AppTheme.inputIconColor,
      ),
      onPressed: onPressed,
    );
  }

  void _onSaveChanges() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => ChangePasswordBottomSheet(
        onConfirm: () {
          // TODO(backend): call the change-password API here once the
          // backend is available.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.changePassword),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: AppText.oldPassword,
                        hint: AppText.enterYourPassword,
                        controller: _oldPasswordController,
                        obscureText: _obscureOldPassword,
                        validator: Validators.password,
                        suffixIcon: _eyeToggle(
                          _obscureOldPassword,
                          () => setState(
                            () => _obscureOldPassword = !_obscureOldPassword,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      AppTextField(
                        label: AppText.newPassword,
                        hint: AppText.enterYourPassword,
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        validator: Validators.password,
                        suffixIcon: _eyeToggle(
                          _obscureNewPassword,
                          () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      AppTextField(
                        label: AppText.confirmNewPassword,
                        hint: AppText.enterYourPassword,
                        controller: _confirmNewPasswordController,
                        obscureText: _obscureConfirmNewPassword,
                        validator: (value) => Validators.match(
                          value,
                          _newPasswordController.text,
                          message: 'Passwords do not match',
                        ),
                        suffixIcon: _eyeToggle(
                          _obscureConfirmNewPassword,
                          () => setState(
                            () => _obscureConfirmNewPassword =
                                !_obscureConfirmNewPassword,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),

                      AppButton(
                        text: AppText.saveTheChanges,
                        onPressed: _onSaveChanges,
                        width: double.infinity,
                        backgroundColor: AppColors.brandPrimary,
                        textColor: AppColors.white,
                        radius: ResponsiveHelper.borderRadius(10),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
