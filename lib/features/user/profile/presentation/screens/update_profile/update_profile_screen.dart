import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/user/profile/presentation/providers/user_profile_notifier.dart';
import 'package:nchito/features/user/profile/presentation/widgets/save_profile_changes_bottom_sheet.dart';

/// Lets the user edit their name and phone number. Email stays locked
/// (shown as a notice) since it is tied to the account. Navigated to from
/// [MyProfileScreen]'s "Update Profile" button.
class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  String? _pickedAvatarPath;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileNotifier>().profile;
    if (profile != null) {
      _nameController = TextEditingController(
        text: profile.fullName.trim().isNotEmpty
            ? profile.fullName.trim()
            : AppText.userNameVaughan,
      );
      final phone = (profile.phone != null && profile.phone!.trim().isNotEmpty)
          ? profile.phone!.trim()
          : (profile.email ?? AppText.userPhoneVaughan);
      _phoneController = TextEditingController(text: phone);
      _controllersInitialized = true;
    } else {
      _nameController = TextEditingController(text: AppText.userNameVaughan);
      _phoneController = TextEditingController(text: AppText.userPhoneVaughan);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserProfileNotifier>().fetchProfile();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllersInitialized) {
      final profile = context.watch<UserProfileNotifier>().profile;
      if (profile != null) {
        if (profile.fullName.trim().isNotEmpty) {
          _nameController.text = profile.fullName.trim();
        }
        final phone = (profile.phone != null && profile.phone!.trim().isNotEmpty)
            ? profile.phone!.trim()
            : (profile.email ?? '');
        if (phone.isNotEmpty) {
          _phoneController.text = phone;
        }
        _controllersInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null) {
          setState(() {
            _pickedAvatarPath = path;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to select image.');
      }
    }
  }

  void _onSaveChanges() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your name.');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => SaveProfileChangesBottomSheet(
        onConfirm: () async {
          Navigator.of(context).pop();
          final notifier = context.read<UserProfileNotifier>();
          final success = await notifier.updateProfile(
            fullName: name,
            avatarPath: _pickedAvatarPath,
          );
          if (!mounted) return;
          if (success) {
            AppSnackbar.showSuccess(context, 'Profile updated successfully.');
            context.pop();
          } else {
            AppSnackbar.showError(
              context,
              notifier.updateErrorMessage ?? 'Failed to update profile.',
            );
          }
        },
      ),
    );
  }

  Widget _buildAvatar(String? serverAvatar) {
    Widget image;
    if (_pickedAvatarPath != null) {
      image = Image.file(
        File(_pickedAvatarPath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetsPath.avatarUser,
          fit: BoxFit.cover,
        ),
      );
    } else if (serverAvatar != null && serverAvatar.trim().isNotEmpty) {
      image = Image.network(
        serverAvatar,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetsPath.avatarUser,
          fit: BoxFit.cover,
        ),
      );
    } else {
      image = Image.asset(
        AssetsPath.avatarUser,
        fit: BoxFit.cover,
      );
    }

    return Center(
      child: GestureDetector(
        onTap: _pickAvatar,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: ResponsiveHelper.width(100),
              height: ResponsiveHelper.width(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(24),
                ),
                border: Border.all(
                  color: AppColors.borderDefault,
                  width: ResponsiveHelper.borderWidth(1),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(23),
                ),
                child: image,
              ),
            ),
            Positioned(
              bottom: ResponsiveHelper.spacing(4),
              right: ResponsiveHelper.spacing(4),
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.padding(3),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(4),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.brandGradientStart,
                      AppColors.brandGradientEnd,
                    ],
                  ),
                ),
                child: AppIcon(
                  assetPath: AssetsPath.updateProfileIconCamera,
                  size: ResponsiveHelper.iconSize(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.updateProfile),
            Expanded(
              child: Consumer<UserProfileNotifier>(
                builder: (context, notifier, child) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.padding(24),
                    ),
                    child: Column(
                      children: [
                        // Avatar with photo-edit badge
                        _buildAvatar(notifier.profile?.avatar),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        AppTextField(
                          label: AppText.fullName,
                          hint: AppText.enterYourFullName,
                          controller: _nameController,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(16)),
                        AppTextField(
                          label: AppText.phoneNumber,
                          hint: AppText.enterYourPhoneNumber,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        AppButton(
                          text: AppText.saveTheChanges,
                          onPressed:
                              notifier.isUpdating ? null : _onSaveChanges,
                          width: double.infinity,
                          backgroundColor: AppColors.brandPrimary,
                          textColor: AppColors.white,
                          radius: ResponsiveHelper.borderRadius(10),
                          child: notifier.isUpdating
                              ? SizedBox(
                                  width: ResponsiveHelper.width(20),
                                  height: ResponsiveHelper.width(20),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        // Email locked notice
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: ResponsiveHelper.width(44),
                              height: ResponsiveHelper.width(44),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(10),
                                ),
                              ),
                              child: AppIcon(
                                assetPath: AssetsPath.updateProfileIconEmailLocked,
                                size: ResponsiveHelper.iconSize(20),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(6)),
                            Expanded(
                              child: Text(
                                AppText
                                    .yourEmailAddressIsLinkedToYourNchitoAccountAndIsUsedForImportantAccountAndSecurityUpdatesSoItCannotBeChangedAtThisTime,
                                style: context.bodySmall.copyWith(
                                  fontSize: ResponsiveHelper.fontSize(10),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
