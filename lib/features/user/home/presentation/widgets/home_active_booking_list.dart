import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/user/home/presentation/screens/booking_details/booking_details_screen.dart';

import 'booking_list_tile.dart';
import 'home_sample_data.dart';

/// The "Active Booking" list on Home.
class HomeActiveBookingList extends StatelessWidget {
  const HomeActiveBookingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: homeActiveBookings
          .map(
            (booking) => Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(12)),
              child: BookingListTile(
                iconAsset: booking.iconAsset,
                iconBgColor: booking.iconBgColor,
                iconColor: booking.iconColor,
                providerName: booking.providerName,
                service: booking.service,
                price: booking.price,
                date: booking.date,
                time: booking.time,
                onTap: () => context.push(
                  BookingDetailsScreen.routeName,
                  extra: booking,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
