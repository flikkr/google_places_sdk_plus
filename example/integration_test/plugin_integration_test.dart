import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initialize test', (WidgetTester tester) async {
    final places = PlacesHostApi();
    // This should not throw if the native side is correctly set up,
    // even with an invalid key, initialization usually succeeds in the SDK
    // (it errors out when you actually make a request).
    await places.initialize('test-api-key');
    expect(true, true);
  });
}
