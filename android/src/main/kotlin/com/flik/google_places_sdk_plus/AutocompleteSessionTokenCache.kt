package com.flik.google_places_sdk_plus

import com.google.android.libraries.places.api.model.AutocompleteSessionToken

object AutocompleteSessionTokenCache {
    private val tokens = mutableMapOf<String, AutocompleteSessionToken>()

    fun getOrCreate(tokenString: String?): AutocompleteSessionToken {
        if (tokenString == null || tokenString.isEmpty()) {
            return AutocompleteSessionToken.newInstance()
        }
        return tokens.getOrPut(tokenString) {
            AutocompleteSessionToken.newInstance()
        }
    }

    fun remove(tokenString: String?) {
        if (tokenString != null) {
            tokens.remove(tokenString)
        }
    }
}
