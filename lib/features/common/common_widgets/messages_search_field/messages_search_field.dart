import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Reusable search input for messages list screens (User and Provider)
/// with a search icon on the left over a translucent fill.
class MessagesSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MessagesSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.height(44),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: Row(
        children: [
          AppIcon(
            assetPath: AssetsPath.messagesIconSearch,
            size: ResponsiveHelper.iconSize(16),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: context.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: AppText.searchByName,
                hintStyle: context.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
