import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/validators/validators.dart';
import 'package:nchito/features/provider/auth/presentation/screens/login/provider_login_screen.dart';

class ProviderSetNewPasswordScreen extends StatefulWidget {
  static const String routeName = '/provider/set-new-password';

  const ProviderSetNewPasswordScreen({super.key});

  @override
  State<ProviderSetNewPasswordScreen> createState() =>
      _ProviderSetNewPasswordScreenState();
}

class _ProviderSetNewPasswordScreenState
    extends State<ProviderSetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  void _onUpdatePasswordPressed() {
    context.go(ProviderLoginScreen.routeName);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthHeader(
                          title: AppText.setNewPasswordTitle,
                          subtitle: AppText
                              .createANewPasswordForYourAccountToContinueSecurely,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),

                        AppTextField(
                          label: AppText.newPassword,
                          hint: AppText.enterYourPassword,
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          validator: Validators.password,
                          suffixIcon: IconButton(
                            icon: AppIcon(
                              assetPath: AssetsPath.logInIconEyeToggle,
                              size: ResponsiveHelper.iconSize(16),
                              color: AppTheme.inputIconColor,
                            ),
                            onPressed: () {
                              setState(
                                () =>
                                    _obscureNewPassword = !_obscureNewPassword,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20)),

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
                          suffixIcon: IconButton(
                            icon: AppIcon(
                              assetPath:
                                  AssetsPath.setNewPasswordIconEyeVisible,
                              size: ResponsiveHelper.iconSize(16),
                              color: AppTheme.inputIconColor,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscureConfirmNewPassword =
                                    !_obscureConfirmNewPassword,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        ElevatedButton(
                          onPressed: _onUpdatePasswordPressed,
                          child: Text(AppText.updatePassword),
                        ),
                      ],
                    ),
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
