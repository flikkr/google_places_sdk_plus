package com.flik.google_places_sdk_plus

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** GooglePlacesSdkPlusPlugin */
class GooglePlacesSdkPlusPlugin : FlutterPlugin {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        PlacesHostApi.setUp(
            flutterPluginBinding.binaryMessenger,
            PlacesClientImpl(flutterPluginBinding.applicationContext)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        PlacesHostApi.setUp(binding.binaryMessenger, null)
    }
}
