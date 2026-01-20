package com.flik.google_places_sdk_plus

import android.content.Context
import android.util.Log
import com.google.android.gms.maps.model.LatLng
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.CircularBounds
import com.google.android.libraries.places.api.model.RectangularBounds
import com.google.android.libraries.places.api.model.AutocompletePrediction as NativeAutocompletePrediction
import com.google.android.libraries.places.api.model.Place as NativePlace
import com.google.android.libraries.places.api.net.PlacesClient
import com.google.android.libraries.places.api.net.FetchPlaceRequest as NativeFetchPlaceRequest
import com.google.android.libraries.places.api.net.SearchByTextRequest as NativeSearchByTextRequest
import com.google.android.libraries.places.api.net.SearchNearbyRequest as NativeSearchNearbyRequest
import com.google.android.libraries.places.api.net.FetchResolvedPhotoUriRequest as NativeFetchResolvedPhotoUriRequest

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
        PhotoMetadataCache.clear()
    }

    override fun fetchPlace(
        request: FetchPlaceRequest,
        callback: (Result<FetchPlaceResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val builder = NativeFetchPlaceRequest.builder(
                request.placeId,
                request.placeFields.map { NativePlace.Field.valueOf(it.name) }
            )

            request.sessionToken?.let {
                builder.setSessionToken(AutocompleteSessionTokenCache.getOrCreate(it))
                AutocompleteSessionTokenCache.remove(it)
            }

            val nativeRequest = builder.build()

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
                builder.setPriceLevels(levels.map { it.toInt() })
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


    override fun searchNearby(
        request: SearchNearbyRequest,
        callback: (Result<SearchNearbyResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val center = LatLng(
                request.locationRestriction.center.lat,
                request.locationRestriction.center.lng
            )
            val circularBounds =
                CircularBounds.newInstance(center, request.locationRestriction.radius)

            val builder = NativeSearchNearbyRequest.builder(
                circularBounds,
                request.placeFields.map { NativePlace.Field.valueOf(it.name) }
            )

            request.includedTypes?.let { builder.setIncludedTypes(it) }
            request.excludedTypes?.let { builder.setExcludedTypes(it) }
            request.includedPrimaryTypes?.let { builder.setIncludedPrimaryTypes(it) }
            request.excludedPrimaryTypes?.let { builder.setExcludedPrimaryTypes(it) }
            request.maxResultCount?.let { builder.setMaxResultCount(it.toInt()) }
            request.rankPreference?.let {
                builder.setRankPreference(
                    NativeSearchNearbyRequest.RankPreference.valueOf(request.rankPreference.name)
                )
            }

            client.searchNearby(builder.build())
                .addOnSuccessListener { response ->
                    try {
                        callback(Result.success(SearchNearbyResponse(response.places.map { it.toPigeon() })))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error mapping SearchNearbyResponse to Pigeon", e)
                        callback(Result.failure(e))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e(TAG, "Error searching nearby", exception)
                    callback(Result.failure(exception))
                }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in searchByNearby", e)
            callback(Result.failure(e))
        }
    }

    override fun fetchPhoto(
        request: FetchPhotoRequest,
        callback: (Result<FetchPhotoResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val photoReference = request.photoMetadata.photoReference
                ?: throw Exception("Photo reference is missing")

            val nativePhotoMetadata = PhotoMetadataCache.get(photoReference)
                ?: throw Exception("Photo metadata expired or invalid")

            val builder = NativeFetchResolvedPhotoUriRequest.builder(nativePhotoMetadata)
            request.maxWidth?.let { builder.setMaxWidth(it.toInt()) }
            request.maxHeight?.let { builder.setMaxHeight(it.toInt()) }

            client.fetchResolvedPhotoUri(builder.build())
                .addOnSuccessListener { fetchPhotoResponse ->
                    try {
                        val uri = fetchPhotoResponse.uri
                        callback(Result.success(FetchPhotoResponse(uri?.toString())))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error processing FetchPhotoResponse", e)
                        callback(Result.failure(e))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e(TAG, "Error fetching photo", exception)
                    callback(Result.failure(exception))
                }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in fetchPhoto", e)
            callback(Result.failure(e))
        }
    }

    override fun fetchAutocompletePredictions(
        request: FetchAutocompletePredictionsRequest,
        callback: (Result<FetchAutocompletePredictionsResponse>) -> Unit
    ) {
        try {
            val client = placesClient
                ?: throw Exception("Places SDK is not initialized. Call initialize() first.")

            val builder =
                com.google.android.libraries.places.api.net.FindAutocompletePredictionsRequest.builder()

            request.query?.let { builder.setQuery(it) }
            request.countries?.let { builder.setCountries(it) }
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
            request.origin?.let { builder.setOrigin(LatLng(it.lat, it.lng)) }
            request.typesFilter?.let { filters ->
                builder.setTypesFilter(filters.map { type ->
                    when (type) {
                        PlaceTypes.CITIES -> "(cities)"
                        PlaceTypes.REGIONS -> "(regions)"
                        else -> type.name.lowercase()
                    }
                })
            }

            val sessionToken = AutocompleteSessionTokenCache.getOrCreate(request.sessionToken)
            builder.setSessionToken(sessionToken)

            client.findAutocompletePredictions(builder.build())
                .addOnSuccessListener { response ->
                    try {
                        val predictions = response.autocompletePredictions.map { it.toPigeon() }
                        callback(Result.success(FetchAutocompletePredictionsResponse(predictions)))
                    } catch (e: Exception) {
                        Log.e(TAG, "Error mapping FetchAutocompletePredictionsResponse", e)
                        callback(Result.failure(e))
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e(TAG, "Error fetching autocomplete predictions", exception)
                    callback(Result.failure(exception))
                }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in fetchAutocompletePredictions", e)
            callback(Result.failure(e))
        }
    }

    private fun NativeAutocompletePrediction.toPigeon(): AutocompletePrediction {
        return AutocompletePrediction(
            placeId = this.placeId,
            primaryText = this.getPrimaryText(null).toString(),
            secondaryText = this.getSecondaryText(null).toString(),
            fullText = this.getFullText(null).toString(),
            distanceMeters = this.distanceMeters?.toLong(),
            placeTypes = this.types
        )
    }
}
