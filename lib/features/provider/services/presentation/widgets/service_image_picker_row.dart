import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Image upload row widget for Add Service screen.
/// Displays an "Upload Images Here" picker card and uploaded image thumbnails with delete action.
class ServiceImagePickerRow extends StatefulWidget {
  final ValueChanged<List<String>>? onImagesChanged;

  const ServiceImagePickerRow({
    super.key,
    this.onImagesChanged,
  });

  @override
  State<ServiceImagePickerRow> createState() => _ServiceImagePickerRowState();
}

class _ServiceImagePickerRowState extends State<ServiceImagePickerRow> {
  final List<String> _images = [AssetsPath.providerDetailsPhoto];

  void _onAddImage() {
    setState(() {
      _images.add(AssetsPath.providerDetailsPhoto);
    });
    widget.onImagesChanged?.call(_images);
  }

  void _onRemoveImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged?.call(_images);
  }

  @override
  Widget build(BuildContext context) {
    final boxWidth = ResponsiveHelper.width(115);
    final boxHeight = ResponsiveHelper.height(105);
    final boxRadius = ResponsiveHelper.borderRadius(16);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Upload Images Here Box
          GestureDetector(
            onTap: _onAddImage,
            child: Container(
              width: boxWidth,
              height: boxHeight,
              padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F4F1),
                borderRadius: BorderRadius.circular(boxRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: ResponsiveHelper.iconSize(26),
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(6)),
                  Text(
                    AppText.uploadImagesHere,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11.5),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),

          // Uploaded image thumbnails
          ..._images.asMap().entries.map((entry) {
            final index = entry.key;
            final imageAsset = entry.value;

            return Container(
              width: boxWidth,
              height: boxHeight,
              margin: EdgeInsets.only(right: ResponsiveHelper.spacing(12)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(boxRadius),
                    child: Image.asset(
                      imageAsset,
                      width: boxWidth,
                      height: boxHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: boxWidth,
                        height: boxHeight,
                        color: AppColors.brandSoft,
                        child: Icon(
                          Icons.person,
                          color: AppColors.brandPrimary,
                          size: ResponsiveHelper.iconSize(32),
                        ),
                      ),
                    ),
                  ),
                  // Close/remove button on top-right
                  Positioned(
                    top: ResponsiveHelper.spacing(6),
                    right: ResponsiveHelper.spacing(6),
                    child: GestureDetector(
                      onTap: () => _onRemoveImage(index),
                      child: Container(
                        width: ResponsiveHelper.width(22),
                        height: ResponsiveHelper.width(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: ResponsiveHelper.iconSize(13),
                          color: AppColors.textBlackPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
