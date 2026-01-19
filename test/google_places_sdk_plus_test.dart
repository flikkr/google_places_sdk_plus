import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus_platform_interface.dart';
import 'package:google_places_sdk_plus/google_places_sdk_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGooglePlacesSdkPlusPlatform
    with MockPlatformInterfaceMixin
    implements GooglePlacesSdkPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GooglePlacesSdkPlusPlatform initialPlatform = GooglePlacesSdkPlusPlatform.instance;

  test('$MethodChannelGooglePlacesSdkPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGooglePlacesSdkPlus>());
  });

  test('getPlatformVersion', () async {
    GooglePlacesSdkPlus googlePlacesSdkPlusPlugin = GooglePlacesSdkPlus();
    MockGooglePlacesSdkPlusPlatform fakePlatform = MockGooglePlacesSdkPlusPlatform();
    GooglePlacesSdkPlusPlatform.instance = fakePlatform;

    expect(await googlePlacesSdkPlusPlugin.getPlatformVersion(), '42');
  });
}
