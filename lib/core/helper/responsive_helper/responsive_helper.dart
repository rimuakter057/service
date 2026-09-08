import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum DeviceType {
  mobile,
  tablet,
}

class ResponsiveHelper {
  ResponsiveHelper._();

  // ============================================================
  // BREAKPOINT
  // ============================================================

  static const double _tabletBreakpoint = 600;

  // ============================================================
  // SCREEN INFORMATION
  // ============================================================

  static double _screenWidth = 375;
  static double _screenHeight = 812;

  static double _textScaleFactor = 1.0;

  static EdgeInsets _safeAreaPadding = EdgeInsets.zero;

  static Orientation _orientation = Orientation.portrait;

  static bool _isInitialized = false;

  // ============================================================
  // INITIALIZE
  // ============================================================

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    _orientation = mediaQuery.orientation;

    _safeAreaPadding = mediaQuery.padding;

    _textScaleFactor =
        mediaQuery.textScaler.scale(1.0).clamp(0.85, 1.2);

    _isInitialized = true;
  }

  // ============================================================
  // GETTERS
  // ============================================================

  static bool get isInitialized => _isInitialized;

  static double get screenWidth => _screenWidth;

  static double get screenHeight => _screenHeight;

  static Orientation get orientation => _orientation;

  static EdgeInsets get safeAreaPadding => _safeAreaPadding;

  // ============================================================
  // DEVICE TYPE
  // ============================================================

  static DeviceType get deviceType {
    if (_screenWidth >= _tabletBreakpoint) {
      return DeviceType.tablet;
    }

    return DeviceType.mobile;
  }

  // ============================================================
  // DEVICE CHECK
  // ============================================================

  static bool get isMobile => deviceType == DeviceType.mobile;

  static bool get isTablet => deviceType == DeviceType.tablet;

  static bool get isLandscape =>
      _orientation == Orientation.landscape;

  static bool get isPortrait =>
      _orientation == Orientation.portrait;

  // ============================================================
  // DEVICE BASED VALUE
  // ============================================================

  static T value<T>({
    required T mobile,
    T? tablet,
  }) {
    if (isTablet) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  // ============================================================
  // INTERNAL SCALE
  // ============================================================

  static double _scale(
      double value, {
        double tabletMultiplier = 1.0,
      }) {
    if (isTablet) {
      return value * tabletMultiplier;
    }

    return value;
  }

  // ============================================================
  // FONT SIZE
  // ============================================================

  static double fontSize(
      double mobileSize, {
        double tabletMultiplier = 1.15,
      }) {
    return _scale(
      mobileSize,
      tabletMultiplier: tabletMultiplier,
    ) *
        _textScaleFactor;
  }

  // ============================================================
  // TITLE FONT SIZE
  // ============================================================

  static double titleFontSize(
      double mobileSize, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileSize,
      tabletMultiplier: tabletMultiplier,
    ) *
        _textScaleFactor;
  }

  // ============================================================
  // SPACING
  // ============================================================

  static double spacing(
      double mobileSpacing, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileSpacing,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // PADDING
  // ============================================================

  static double padding(
      double mobilePadding, {
        double tabletMultiplier = 1.5,
      }) {
    return _scale(
      mobilePadding,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // WIDTH
  // ============================================================

  static double width(
      double mobileWidth, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileWidth,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // HEIGHT
  // ============================================================

  static double height(
      double mobileHeight, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileHeight,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // ICON SIZE
  // ============================================================

  static double iconSize(
      double mobileIconSize, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileIconSize,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // BORDER WIDTH
  // ============================================================

  static double borderWidth(
      double mobileBorderWidth, {
        double tabletMultiplier = 1.5,
      }) {
    return _scale(
      mobileBorderWidth,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  static double borderRadius(
      double mobileRadius, {
        double tabletMultiplier = 1.2,
      }) {
    return _scale(
      mobileRadius,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // BUTTON HEIGHT
  // ============================================================

  static double buttonHeight(
      double mobileHeight, {
        double tabletMultiplier = 1.15,
      }) {
    return _scale(
      mobileHeight,
      tabletMultiplier: tabletMultiplier,
    );
  }

  // ============================================================
  // WIDTH PERCENTAGE
  // ============================================================

  static double widthPercent(double percent) {
    return _screenWidth * (percent / 100);
  }

  // ============================================================
  // HEIGHT PERCENTAGE
  // ============================================================

  static double heightPercent(double percent) {
    return _screenHeight * (percent / 100);
  }

  // ============================================================
  // MAX CONTENT WIDTH
  // ============================================================

  static double get maxContentWidth {
    if (isTablet) {
      return 600;
    }

    return _screenWidth;
  }

  // ============================================================
  // GRID COLUMNS
  // ============================================================

  static int gridColumns({
    int mobile = 2,
    int tablet = 3,
  }) {
    return value(
      mobile: mobile,
      tablet: tablet,
    );
  }
}

// ================================================================
// RESPONSIVE WRAPPER
// ================================================================

class ResponsiveWrapper extends StatefulWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ResponsiveWrapper> createState() =>
      _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ResponsiveHelper.init(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ResponsiveHelper.init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return widget.child;
  }
}