package com.flik.google_places_sdk_plus

import android.content.Context
import android.util.Log
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.libraries.places.api.net.FetchPlaceRequest as NativeFetchPlaceRequest
import com.google.android.libraries.places.api.model.Place as NativePlace

class PlacesClientImpl(private val context: Context) : PlacesHostApi {
    companion object {
        const val TAG = "PlacesClientImpl"
    }

    private var placesClient: PlacesClient? = null

    override fun initialize(apiKey: String) {
        Log.d(TAG, "Initializing Places SDK with API key $apiKey")
        if (!Places.isInitialized()) {
            Places.initializeWithNewPlacesApiEnabled(context, apiKey)
        }
        placesClient = Places.createClient(context)
    }

    override fun fetchPlace(
        request: FetchPlaceRequest,
        callback: (Result<FetchPlaceResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val nativeRequest = NativeFetchPlaceRequest.newInstance(
                request.placeId,
                request.placeFields.map { NativePlace.Field.valueOf(it.name) })

            client.fetchPlace(nativeRequest)
                .addOnSuccessListener { response ->
                    try {
                        callback(Result.success(response.toPigeon()))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error mapping FetchPlaceResponse to Pigeon", e)
                        callback(Result.failure(e))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e(TAG, "Error fetching place details", exception)
                    callback(Result.failure(exception))
                }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in fetchPlace", e)
            callback(Result.failure(e))
        }
    }
}
