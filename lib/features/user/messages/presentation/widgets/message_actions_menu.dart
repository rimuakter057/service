import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Shows the "Block"/"Unblock" + "Delete" actions popup anchored at
/// [position] — matching the Figma design frame.
Future<void> showMessageActionsMenu(
  BuildContext context,
  Offset position, {
  bool isBlocked = false,
  VoidCallback? onToggleBlock,
  VoidCallback? onDelete,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final menuWidth = ResponsiveHelper.width(240);

  final selected = await showMenu<String>(
    context: context,
    color: AppColors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black.withValues(alpha: 0.15),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
    ),
    clipBehavior: Clip.antiAlias,
    position: RelativeRect.fromLTRB(
      overlay.size.width - menuWidth - ResponsiveHelper.padding(16),
      position.dy + ResponsiveHelper.spacing(12),
      ResponsiveHelper.padding(16),
      0,
    ),
    constraints: BoxConstraints(
      minWidth: menuWidth,
      maxWidth: menuWidth + ResponsiveHelper.width(20),
    ),
    items: [
      PopupMenuItem<String>(
        value: 'toggleBlock',
        padding: EdgeInsets.zero,
        height: ResponsiveHelper.height(60),
        child: _ActionMenuRow(
          iconAsset: isBlocked
              ? AssetsPath.messagesIconUnblock
              : AssetsPath.messagesIconBlock,
          label: isBlocked ? AppText.unblock : AppText.block,
        ),
      ),
      const _MenuDivider(),
      PopupMenuItem<String>(
        value: 'delete',
        padding: EdgeInsets.zero,
        height: ResponsiveHelper.height(60),
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

/// Custom thin divider between menu entries.
class _MenuDivider extends PopupMenuEntry<Never> {
  const _MenuDivider();

  @override
  double get height => 1.0;

  @override
  bool represents(void value) => false;

  @override
  State<_MenuDivider> createState() => _MenuDividerState();
}

class _MenuDividerState extends State<_MenuDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: AppColors.bgOverlay.withValues(alpha: 0.06),
    );
  }
}

/// One row ("Block" / "Unblock" / "Delete") inside the actions menu.
class _ActionMenuRow extends StatelessWidget {
  final String iconAsset;
  final String label;

  const _ActionMenuRow({required this.iconAsset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),
        vertical: ResponsiveHelper.padding(16),
      ),
      child: Row(
        children: [
          AppIcon(
            assetPath: iconAsset,
            size: ResponsiveHelper.iconSize(24),
          ),
          SizedBox(width: ResponsiveHelper.spacing(16)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackPrimary,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: ResponsiveHelper.iconSize(24),
            color: AppColors.textGreyPrimary,
          ),
        ],
      ),
    );
  }
}
