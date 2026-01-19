import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'google_places_sdk_plus_method_channel.dart';

abstract class GooglePlacesSdkPlusPlatform extends PlatformInterface {
  /// Constructs a GooglePlacesSdkPlusPlatform.
  GooglePlacesSdkPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static GooglePlacesSdkPlusPlatform _instance =
      MethodChannelGooglePlacesSdkPlus();

  /// The default instance of [GooglePlacesSdkPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelGooglePlacesSdkPlus].
  static GooglePlacesSdkPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GooglePlacesSdkPlusPlatform] when
  /// they register themselves.
  static set instance(GooglePlacesSdkPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
