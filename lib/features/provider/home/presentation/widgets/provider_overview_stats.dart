import 'package:flutter/material.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

class _StatCardData {
  final String value;
  final String label;
  final Color bgColor;
  final Color valueColor;

  const _StatCardData({
    required this.value,
    required this.label,
    required this.bgColor,
    required this.valueColor,
  });
}

/// Row of 3 stat cards on the Provider Home screen ("Today's Overview") —
/// pending requests, upcoming bookings, and today's bookings counts.
class ProviderOverviewStats extends StatelessWidget {
  final String pendingRequests;
  final String upcomingBookings;
  final String todaysBookings;

  const ProviderOverviewStats({
    super.key,
    required this.pendingRequests,
    required this.upcomingBookings,
    required this.todaysBookings,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCardData(
        value: pendingRequests,
        label: AppText.pendingRequests,
        bgColor: AppColors.brandSoft,
        valueColor: AppColors.brandPrimary,
      ),
      _StatCardData(
        value: upcomingBookings,
        label: AppText.upcomingBookings,
        bgColor: AppColors.orange100,
        valueColor: AppColors.orange400,
      ),
      _StatCardData(
        value: todaysBookings,
        label: AppText.todaysBookings,
        bgColor: AppColors.emerald100,
        valueColor: AppColors.emerald400,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) SizedBox(width: ResponsiveHelper.spacing(10)),
          Expanded(child: _StatCard(data: cards[i])),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: data.bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.value,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(16),
              fontWeight: FontWeight.bold,
              color: data.valueColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),
          Text(
            data.label,
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
