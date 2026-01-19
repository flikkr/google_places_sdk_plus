// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'google_places_sdk_plus_platform_interface.dart';

/// A web implementation of the GooglePlacesSdkPlusPlatform of the GooglePlacesSdkPlus plugin.
class GooglePlacesSdkPlusWeb extends GooglePlacesSdkPlusPlatform {
  /// Constructs a GooglePlacesSdkPlusWeb
  GooglePlacesSdkPlusWeb();

  static void registerWith(Registrar registrar) {
    GooglePlacesSdkPlusPlatform.instance = GooglePlacesSdkPlusWeb();
  }
}
