import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Shows the "Block"/"Unblock" + "Delete" actions popup anchored at
/// [position] — used by the Chat screen's overflow ("...") button. Shows
/// "Unblock" in place of "Block" when [isBlocked] is true.
Future<void> showMessageActionsMenu(
  BuildContext context,
  Offset position, {
  bool isBlocked = false,
  VoidCallback? onToggleBlock,
  VoidCallback? onDelete,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final selected = await showMenu<String>(
    context: context,
    color: AppColors.bgApp,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
    ),
    position: RelativeRect.fromRect(
      position & const Size(1, 1),
      Offset.zero & overlay.size,
    ),
    items: [
      PopupMenuItem(
        value: 'toggleBlock',
        child: _ActionMenuRow(
          iconAsset: isBlocked
              ? AssetsPath.messagesIconUnblock
              : AssetsPath.messagesIconBlock,
          label: isBlocked ? AppText.unblock : AppText.block,
        ),
      ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem(
        value: 'delete',
        child: _ActionMenuRow(
          iconAsset: AssetsPath.messagesIconDelete,
          label: AppText.delete,
        ),
      ),
    ],
  );
  if (selected == 'toggleBlock') onToggleBlock?.call();
  if (selected == 'delete') onDelete?.call();
}

/// One row ("Block" / "Delete") inside the actions menu.
class _ActionMenuRow extends StatelessWidget {
  final String iconAsset;
  final String label;

  const _ActionMenuRow({required this.iconAsset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(assetPath: iconAsset, size: ResponsiveHelper.iconSize(14)),
        SizedBox(width: ResponsiveHelper.spacing(8)),
        Text(
          label,
          style: context.bodySmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(12),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: ResponsiveHelper.spacing(16)),
        Icon(
          Icons.chevron_right_rounded,
          size: ResponsiveHelper.iconSize(14),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
