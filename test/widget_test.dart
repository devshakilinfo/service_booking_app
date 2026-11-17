import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking_app/main.dart';

void main() {
  testWidgets('ServiceHub App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ServiceHubApp());

    // Verify that the ServiceHub brand title renders
    expect(find.text('ServiceHub'), findsWidgets);
  });
}
