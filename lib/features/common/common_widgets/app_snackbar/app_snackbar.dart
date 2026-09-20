import 'dart:async';

import 'package:flutter/material.dart';

import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

enum _AppSnackbarType { success, error }

/// Top-of-screen success/error banner used across the whole app instead of
/// Flutter's built-in bottom [SnackBar]. Shown via the root [Overlay], so
/// it floats above whatever screen is currently visible and needs no
/// [Scaffold] to be present.
class AppSnackbar {
  const AppSnackbar._();

  static OverlayEntry? _activeEntry;

  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, type: _AppSnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message: message, type: _AppSnackbarType.error);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required _AppSnackbarType type,
  }) {
    // Only one banner on screen at a time — a new one replaces the last.
    _activeEntry?.remove();
    _activeEntry = null;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => _AppSnackbarBanner(
        message: message,
        type: type,
        onDismissed: () {
          _activeEntry?.remove();
          _activeEntry = null;
        },
      ),
    );
    _activeEntry = entry;
    overlay.insert(entry);
  }
}

class _AppSnackbarBanner extends StatefulWidget {
  const _AppSnackbarBanner({
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  final String message;
  final _AppSnackbarType type;
  final VoidCallback onDismissed;

  @override
  State<_AppSnackbarBanner> createState() => _AppSnackbarBannerState();
}

class _AppSnackbarBannerState extends State<_AppSnackbarBanner>
    with SingleTickerProviderStateMixin {
  static const _visibleDuration = Duration(seconds: 3);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  Timer? _autoHideTimer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _autoHideTimer = Timer(_visibleDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _autoHideTimer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.type == _AppSnackbarType.success;
    final backgroundColor = isSuccess ? AppColors.brandPrimary : AppColors.red;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(16),
              vertical: ResponsiveHelper.padding(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(16),
                    vertical: ResponsiveHelper.padding(14),
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(22),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(10)),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: context.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
