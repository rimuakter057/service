import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/bookings/presentation/providers/booking_notifier.dart';
import 'package:nchito/features/user/explore/presentation/screens/book_a_service/book_a_service_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('BookAServiceScreen renders placeholders and clock time picker', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => BookingNotifier(),
          child: BookAServiceScreen(provider: robertJuniorProvider),
        ),
      ),
    );

    await tester.pump();

    // Verify Title & Provider Name
    expect(find.text(AppText.bookAService), findsOneWidget);
    expect(find.text(robertJuniorProvider.name), findsOneWidget);

    // Verify "Select Service Type" placeholder
    expect(find.text('Select Service Type'), findsOneWidget);

    // Verify "Choose Your Time" label and "Choose Your Preferred Time" placeholder
    expect(find.text('Choose Your Time'), findsOneWidget);
    expect(find.text('Choose Your Preferred Time'), findsOneWidget);
    expect(find.byIcon(Icons.access_time_outlined), findsOneWidget);

    // Verify "Service Location" and placeholder
    expect(find.text('Service Location'), findsOneWidget);
    expect(find.text('Enter service address'), findsOneWidget);

    // Verify "Booking Instructions" and placeholder
    expect(find.text('Booking Instructions'), findsOneWidget);
    expect(
      find.text('e.g., describe the issue, access instructions, or specific requirements.'),
      findsOneWidget,
    );

    // Verify "Submit Request" button
    expect(find.text('Submit Request'), findsOneWidget);
  });
}
