import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGooglePlacesSdkPlus platform = MethodChannelGooglePlacesSdkPlus();
  const MethodChannel channel = MethodChannel('google_places_sdk_plus');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
