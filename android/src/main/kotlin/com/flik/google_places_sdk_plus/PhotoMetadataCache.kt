package com.flik.google_places_sdk_plus

import com.google.android.libraries.places.api.model.PhotoMetadata
import java.util.UUID

object PhotoMetadataCache {
    private val cache = mutableMapOf<String, PhotoMetadata>()

    fun put(metadata: PhotoMetadata): String {
        val key = UUID.randomUUID().toString()
        cache[key] = metadata
        return key
    }

    fun get(key: String): PhotoMetadata? {
        return cache[key]
    }

    fun clear() {
        cache.clear()
    }
}
