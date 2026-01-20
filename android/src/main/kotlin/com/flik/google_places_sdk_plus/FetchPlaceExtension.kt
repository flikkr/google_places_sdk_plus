package com.flik.google_places_sdk_plus

import com.google.android.libraries.places.api.net.FetchPlaceResponse as NativeFetchPlaceResponse
import com.google.android.libraries.places.api.model.Place as NativePlace
import com.google.android.libraries.places.api.model.AddressComponent as NativeAddressComponent
import com.google.android.libraries.places.api.model.AddressComponents as NativeAddressComponents
import com.google.android.libraries.places.api.model.PlusCode as NativePlusCode
import com.google.android.libraries.places.api.model.OpeningHours as NativeOpeningHours
import com.google.android.libraries.places.api.model.Period as NativePeriod
import com.google.android.libraries.places.api.model.TimeOfWeek as NativeTimeOfWeek
import com.google.android.libraries.places.api.model.LocalTime as NativeLocalTime
import com.google.android.libraries.places.api.model.PhotoMetadata as NativePhotoMetadata
import com.google.android.libraries.places.api.model.Review as NativeReview
import com.google.android.libraries.places.api.model.AuthorAttribution as NativeAuthorAttribution
import com.google.android.libraries.places.api.model.AccessibilityOptions as NativeAccessibilityOptions
import com.google.android.libraries.places.api.model.ParkingOptions as NativeParkingOptions
import com.google.android.libraries.places.api.model.PaymentOptions as NativePaymentOptions
import com.google.android.libraries.places.api.model.EVChargeOptions as NativeEVChargeOptions
import com.google.android.libraries.places.api.model.FuelOptions as NativeFuelOptions
import com.google.android.libraries.places.api.model.FuelPrice as NativeFuelPrice
import com.google.android.libraries.places.api.model.EvChargeAmenitySummary as NativeEvChargeAmenitySummary
import com.google.android.libraries.places.api.model.GenerativeSummary as NativeGenerativeSummary
import com.google.android.libraries.places.api.model.GoogleMapsLinks as NativeGoogleMapsLinks
import com.google.android.libraries.places.api.model.ReviewSummary as NativeReviewSummary
import com.google.android.libraries.places.api.model.SubDestination as NativeSubDestination
import com.google.android.libraries.places.api.model.Money as NativeMoney
import com.google.android.libraries.places.api.model.ContentBlock as NativeContentBlock
import com.google.android.libraries.places.api.model.ConnectorAggregation as NativeConnectorAggregation

fun NativeFetchPlaceResponse.toPigeon(): FetchPlaceResponse {
    return FetchPlaceResponse(place = this.place.toPigeon())
}

fun NativePlace.toPigeon(): Place {
    return Place(
        addressComponents = this.addressComponents?.toPigeon(),
        adrFormatAddress = this.adrFormatAddress,
        businessStatus = if (this.businessStatus != null) BusinessStatus.valueOf(this.businessStatus!!.name) else null,
        displayName = this.displayName,
        displayNameLanguageCode = this.displayNameLanguageCode,
        editorialSummary = this.editorialSummary,
        editorialSummaryLanguageCode = this.editorialSummaryLanguageCode,
        formattedAddress = this.formattedAddress,
        iconMaskUrl = this.iconMaskUrl,
        iconBackgroundColor = this.iconBackgroundColor?.toLong(),
        id = this.id,
        internationalPhoneNumber = this.internationalPhoneNumber,
        location = this.location?.let { LatLng(it.latitude, it.longitude) },
        nationalPhoneNumber = this.nationalPhoneNumber,
        openingHours = this.openingHours?.toPigeon(),
        currentOpeningHours = this.currentOpeningHours?.toPigeon(),
        secondaryOpeningHours = this.secondaryOpeningHours?.map { it?.toPigeon() },
        currentSecondaryOpeningHours = this.currentSecondaryOpeningHours?.map { it?.toPigeon() },
        photoMetadatas = this.photoMetadatas?.map { it?.toPigeon() },
        plusCode = this.plusCode?.toPigeon(),
        priceLevel = this.priceLevel?.toLong(),
        rating = this.rating,
        reviews = this.reviews?.map { it?.toPigeon() },
        types = this.placeTypes,
        userRatingCount = this.userRatingCount?.toLong(),
        utcOffsetMinutes = this.utcOffsetMinutes?.toLong(),
        viewport = this.viewport?.let {
            LatLngBounds(
                LatLng(it.southwest.latitude, it.southwest.longitude),
                LatLng(it.northeast.latitude, it.northeast.longitude)
            )
        },
        websiteUri = this.websiteUri?.toString(),
        googleMapsUri = this.googleMapsUri?.toString(),
        accessibilityOptions = this.accessibilityOptions?.toPigeon(),
        parkingOptions = this.parkingOptions?.toPigeon(),
        paymentOptions = this.paymentOptions?.toPigeon(),
        primaryType = this.primaryType,
        primaryTypeDisplayName = this.primaryTypeDisplayName,
        primaryTypeDisplayNameLanguageCode = this.primaryTypeDisplayNameLanguageCode,
        resourceName = this.resourceName,
        shortFormattedAddress = this.shortFormattedAddress,
        evChargeAmenitySummary = this.evChargeAmenitySummary?.toPigeon(),
        evChargeOptions = this.evChargeOptions?.toPigeon(),
        fuelOptions = this.fuelOptions?.toPigeon(),
        generativeSummary = this.generativeSummary?.toPigeon(),
        googleMapsLinks = this.googleMapsLinks?.toPigeon(),
        reviewSummary = this.reviewSummary?.toPigeon(),
        subDestinations = this.subDestinations?.map { it?.toPigeon() },
        curbsidePickup = this.curbsidePickup.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        delivery = this.delivery.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        dineIn = this.dineIn.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        goodForChildren = this.goodForChildren.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        goodForGroups = this.goodForGroups.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        goodForWatchingSports = this.goodForWatchingSports.name.let {
            BooleanPlaceAttributeValue.valueOf(it)
        },
        liveMusic = this.liveMusic.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        outdoorSeating = this.outdoorSeating.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        menuForChildren = this.menuForChildren.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        reservable = this.reservable.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        restroom = this.restroom.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesBeer = this.servesBeer.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesBreakfast = this.servesBreakfast.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesBrunch = this.servesBrunch.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesCocktails = this.servesCocktails.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesCoffee = this.servesCoffee.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesDessert = this.servesDessert.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesDinner = this.servesDinner.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesLunch = this.servesLunch.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        servesVegetarianFood = this.servesVegetarianFood.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        servesWine = this.servesWine.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        takeout = this.takeout.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        allowsDogs = this.allowsDogs.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        pureServiceAreaBusiness = this.pureServiceAreaBusiness.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
    )
}

fun NativeAddressComponents.toPigeon(): AddressComponents {
    return AddressComponents(components = this.asList().map { it.toPigeon() })
}

fun NativeAddressComponent.toPigeon(): AddressComponent {
    return AddressComponent(
        name = this.name,
        shortName = this.shortName ?: "",
        types = this.types
    )
}

fun NativePlusCode.toPigeon(): PlusCode {
    return PlusCode(compoundCode = this.compoundCode, globalCode = this.globalCode)
}

fun NativeOpeningHours.toPigeon(): OpeningHours {
    return OpeningHours(
        periods = this.periods.map { it.toPigeon() },
        weekdayText = this.weekdayText
    )
}

fun NativePeriod.toPigeon(): Period {
    return Period(open = this.open?.toPigeon(), close = this.close?.toPigeon())
}

fun NativeTimeOfWeek.toPigeon(): TimeOfWeek {
    return TimeOfWeek(day = DayOfWeek.valueOf(this.day.name), time = this.time.toPigeon())
}

fun NativeLocalTime.toPigeon(): LocalTime {
    return LocalTime(hours = this.hours.toLong(), minutes = this.minutes.toLong())
}

fun NativePhotoMetadata.toPigeon(): PhotoMetadata {
    val key = PhotoMetadataCache.put(this)
    return PhotoMetadata(
        width = this.width.toLong(),
        height = this.height.toLong(),
        attributions = this.attributions,
        authorAttributions = this.authorAttributions?.asList()?.map { it.toPigeon() } ?: emptyList(),
        photoReference = key
    )
}

fun NativeReview.toPigeon(): Review {
    return Review(
        name = null,
        relativePublishTimeDescription = this.relativePublishTimeDescription,
        rating = this.rating,
        text = this.text,
        authorAttribution = this.authorAttribution.toPigeon(),
        publishTime = this.publishTime
    )
}

fun NativeAuthorAttribution.toPigeon(): AuthorAttribution {
    return AuthorAttribution(
        name = this.name,
        uri = this.uri,
        photoUri = this.photoUri
    )
}

fun NativeAccessibilityOptions.toPigeon(): AccessibilityOptions {
    return AccessibilityOptions(
        wheelchairAccessibleEntrance = this.wheelchairAccessibleEntrance.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        wheelchairAccessibleRestroom = this.wheelchairAccessibleRestroom.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        wheelchairAccessibleSeating = this.wheelchairAccessibleSeating.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        wheelchairAccessibleParking = this.wheelchairAccessibleParking.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
    )
}

fun NativeParkingOptions.toPigeon(): ParkingOptions {
    return ParkingOptions(
        freeParkingLot = this.freeParkingLot.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        paidParkingLot = this.paidParkingLot.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        freeStreetParking = this.freeStreetParking.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        paidStreetParking = this.paidStreetParking.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        valetParking = this.valetParking.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        freeGarageParking = this.freeGarageParking.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        paidGarageParking = this.paidGarageParking.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
    )
}

fun NativePaymentOptions.toPigeon(): PaymentOptions {
    return PaymentOptions(
        acceptsCreditCards = this.acceptsCreditCards.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        acceptsDebitCards = this.acceptsDebitCards.name.let {
            BooleanPlaceAttributeValue.valueOf(
                it
            )
        },
        acceptsCashOnly = this.acceptsCashOnly.name.let { BooleanPlaceAttributeValue.valueOf(it) },
        acceptsNfc = this.acceptsNfc.name.let { BooleanPlaceAttributeValue.valueOf(it) },
    )
}

fun NativeContentBlock.toPigeon(): ContentBlock {
    return ContentBlock(
        content = this.content,
        contentLanguageCode = this.contentLanguageCode,
        referencedPlaceResourceNames = this.referencedPlaceResourceNames,
        referencedPlaceIds = this.referencedPlaceIds,
    )
}

fun NativeEvChargeAmenitySummary.toPigeon(): EvChargeAmenitySummary {
    return EvChargeAmenitySummary(
        overview = this.overview.toPigeon(),
        coffee = this.coffee?.toPigeon(),
        restaurant = this.restaurant?.toPigeon(),
        store = this.store?.toPigeon(),
        flagContentUri = this.flagContentUri?.toString(),
        disclosureText = this.disclosureText,
        disclosureTextLanguageCode = this.disclosureTextLanguageCode,
    )
}

fun NativeConnectorAggregation.toPigeon(): ConnectorAggregation {
    return ConnectorAggregation(
        type = EVConnectorType.valueOf(this.type.name),
        maxChargeRateKw = this.maxChargeRateKw,
        count = this.count.toLong(),
        availableCount = this.availableCount?.toLong(),
        outOfServiceCount = this.outOfServiceCount?.toLong(),
        availabilityLastUpdateTime = this.availabilityLastUpdateTime?.epochSecond,
    )
}

fun NativeEVChargeOptions.toPigeon(): EVChargeOptions {
    return EVChargeOptions(
        connectorCount = this.connectorCount.toLong(),
        connectorAggregations = this.connectorAggregations.map { it.toPigeon() }
    )
}

fun NativeMoney.toPigeon(): Money {
    return Money(
        currencyCode = this.currencyCode,
        nanos = this.nanos.toLong(),
        units = this.units
    )
}

fun NativeFuelPrice.toPigeon(): FuelPrices {
    return FuelPrices(
        price = this.price.toPigeon(),
        type = FuelType.valueOf(this.type.name),
        updateTime = this.updateTime.epochSecond
    )
}

fun NativeFuelOptions.toPigeon(): FuelOptions {
    return FuelOptions(fuelPrices = this.fuelPrices.map { it.toPigeon() })
}

fun NativeGenerativeSummary.toPigeon(): GenerativeSummary {
    return GenerativeSummary(
        overview = this.overview,
        overviewLanguageCode = this.overviewLanguageCode,
        flagContentUri = this.flagContentUri?.toString(),
        disclosureText = this.disclosureText,
        disclosureTextLanguageCode = this.disclosureTextLanguageCode,
    )
}

fun NativeGoogleMapsLinks.toPigeon(): GoogleMapsLinks {
    return GoogleMapsLinks(
        directionsUri = this.directionsUri?.toString(),
        placeUri = this.placeUri?.toString(),
        writeAReviewUri = this.writeAReviewUri?.toString(),
        reviewsUri = this.reviewsUri?.toString(),
        photosUri = this.photosUri?.toString()
    )
}

fun NativeReviewSummary.toPigeon(): ReviewSummary {
    return ReviewSummary(
        disclosureText = this.disclosureText,
        disclosureTextLanguageCode = this.disclosureTextLanguageCode,
        flagContentUri = this.flagContentUri?.toString(),
        reviewsUri = this.reviewsUri?.toString(),
        text = this.text,
        textLanguageCode = this.textLanguageCode
    )
}

fun NativeSubDestination.toPigeon(): SubDestination {
    return SubDestination(name = this.name, id = this.id)
}
