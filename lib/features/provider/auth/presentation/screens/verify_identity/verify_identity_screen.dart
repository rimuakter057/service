import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_select_sheet/app_select_sheet.dart';
import 'package:nchito/core/common_widgets/auth_header/auth_header.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/auth/presentation/screens/connect_payments/connect_payments_screen.dart';

/// Identity step of the provider sign up flow — reached only when
/// [RoleSelectionScreen] role was `UserRole.provider`, followed by
/// [ConnectPaymentsScreen]. Reuses the same [AuthHeader]/[AppSelectSheet]
/// widgets as the rest of the auth flow instead of introducing
/// screen-specific ones.
class VerifyIdentityScreen extends StatefulWidget {
  static const String routeName = '/verify-identity';

  const VerifyIdentityScreen({super.key});

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  static const List<String> _idTypeOptions = [
    AppText.nationalId,
    AppText.passport,
    AppText.driversLicense,
  ];

  String? _idType = AppText.nationalId;
  String? _uploadedFileName = 'national_id_card.pdf';

  Future<void> _pickIdType() async {
    final result = await AppSelectSheet.show(
      context,
      title: AppText.identificationType,
      options: _idTypeOptions,
      selected: _idType,
    );
    if (result != null) setState(() => _idType = result);
  }

  void _onUploadTapped() {
    // TODO: wire up real file/image picker
    setState(() => _uploadedFileName = 'document.pdf');
  }

  void _onSaveAndContinuePressed() {
    context.push(ConnectPaymentsScreen.routeName);
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
                        title: AppText.verifyYourIdentity,
                        subtitle: AppText
                            .toKeepYourProviderAccountSecureAndReadyToOfferServicesPleaseVerifyYourIdentity,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(32)),

                      Text(
                        AppText.identificationType,
                        style: context.labelLarge,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(8)),
                      _IdTypeField(value: _idType, onTap: _pickIdType),
                      SizedBox(height: ResponsiveHelper.spacing(20)),

                      Text(AppText.uploadId, style: context.labelLarge),
                      SizedBox(height: ResponsiveHelper.spacing(8)),
                      _UploadIdBox(onTap: _onUploadTapped),
                      if (_uploadedFileName != null) ...[
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                        _UploadedFileRow(
                          fileName: _uploadedFileName!,
                          onRemove: () =>
                              setState(() => _uploadedFileName = null),
                        ),
                      ],
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      ElevatedButton(
                        onPressed: _onSaveAndContinuePressed,
                        child: Text(AppText.saveAndContinue),
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

class _IdTypeField extends StatelessWidget {
  final String? value;
  final VoidCallback onTap;

  const _IdTypeField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(16),
          vertical: ResponsiveHelper.padding(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.borderDefault.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? AppText.selectYourIdType,
              style: context.bodyMedium.copyWith(
                color: value != null
                    ? AppColors.textBlackPrimary
                    : AppColors.textGrey,
              ),
            ),
            AppIcon(
              assetPath: AssetsPath.filterIconDropdownChevron,
              size: ResponsiveHelper.iconSize(16),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadIdBox extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadIdBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(24)),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          children: [
            Icon(
              Icons.upload_file_outlined,
              size: ResponsiveHelper.iconSize(28),
              color: AppColors.textGrey,
            ),
            SizedBox(height: ResponsiveHelper.spacing(8)),
            Text(
              AppText.uploadAClearPhotoOfYourId,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadedFileRow extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;

  const _UploadedFileRow({required this.fileName, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(16),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.brandSoft,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: ResponsiveHelper.iconSize(18),
            color: AppColors.brandPrimary,
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),
          Expanded(child: Text(fileName, style: context.bodyMedium)),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.delete_outline,
              size: ResponsiveHelper.iconSize(20),
              color: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}
