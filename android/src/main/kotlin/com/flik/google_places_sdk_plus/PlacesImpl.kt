package com.flik.google_places_sdk_plus

import android.content.Context
import android.util.Log
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.libraries.places.api.net.FetchPlaceRequest as NativeFetchPlaceRequest
import com.google.android.libraries.places.api.net.SearchByTextRequest as NativeSearchByTextRequest
import com.google.android.libraries.places.api.model.Place as NativePlace
import com.google.android.libraries.places.api.model.RectangularBounds
import com.google.android.gms.maps.model.LatLng

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

    override fun searchByText(
        request: SearchByTextRequest,
        callback: (Result<SearchByTextResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val builder = NativeSearchByTextRequest.builder(
                request.textQuery,
                request.placeFields.map { NativePlace.Field.valueOf(it.name) }
            )

            request.includedType?.let { builder.setIncludedType(it) }
            request.maxResultCount?.let { builder.setMaxResultCount(it.toInt()) }
            request.minRating?.let { builder.setMinRating(it) }
            request.isOpenNow?.let { builder.setOpenNow(it) }
            request.priceLevels?.let { levels ->
                builder.setPriceLevels(levels.filterNotNull().map { it.toInt() })
            }
            request.strictTypeFiltering?.let { builder.setStrictTypeFiltering(it) }
            request.locationBias?.let {
                builder.setLocationBias(
                    RectangularBounds.newInstance(
                        LatLng(it.southwest.lat, it.southwest.lng),
                        LatLng(it.northeast.lat, it.northeast.lng)
                    )
                )
            }
            request.locationRestriction?.let {
                builder.setLocationRestriction(
                    RectangularBounds.newInstance(
                        LatLng(it.southwest.lat, it.southwest.lng),
                        LatLng(it.northeast.lat, it.northeast.lng)
                    )
                )
            }

            client.searchByText(builder.build())
                .addOnSuccessListener { response ->
                    try {
                        callback(Result.success(SearchByTextResponse(response.places.map { it.toPigeon() })))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error mapping SearchByTextResponse to Pigeon", e)
                        callback(Result.failure(e))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e(TAG, "Error searching by text", exception)
                    callback(Result.failure(exception))
                }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in searchByText", e)
            callback(Result.failure(e))
        }
    }
}
