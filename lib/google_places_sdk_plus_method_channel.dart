import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'google_places_sdk_plus_platform_interface.dart';

/// An implementation of [GooglePlacesSdkPlusPlatform] that uses method channels.
class MethodChannelGooglePlacesSdkPlus extends GooglePlacesSdkPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_places_sdk_plus');
}
