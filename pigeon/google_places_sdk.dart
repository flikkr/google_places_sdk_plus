// ignore_for_file: constant_identifier_names

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/places.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/flik/google_places_sdk_plus/Places.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.flik.google_places_sdk_plus'),
    dartPackageName: 'google_places_sdk_plus',
  ),
)
@HostApi()
abstract class PlacesHostApi {
  void initialize(String apiKey);

  @async
  FetchPlaceResponse fetchPlace(FetchPlaceRequest request);

  @async
  SearchByTextResponse searchByText(SearchByTextRequest request);

  @async
  SearchByNearbyResponse searchByNearby(SearchByNearbyRequest request);
}

enum PlaceField {
  ACCESSIBILITY_OPTIONS,
  ADDRESS_COMPONENTS,
  ADR_FORMAT_ADDRESS,
  ALLOWS_DOGS,
  BUSINESS_STATUS,
  CONSUMER_ALERT,
  CURBSIDE_PICKUP,
  CURRENT_OPENING_HOURS,
  CURRENT_SECONDARY_OPENING_HOURS,
  DELIVERY,
  DINE_IN,
  DISPLAY_NAME,
  EDITORIAL_SUMMARY,
  EV_CHARGE_AMENITY_SUMMARY,
  EV_CHARGE_OPTIONS,
  FORMATTED_ADDRESS,
  FUEL_OPTIONS,
  GENERATIVE_SUMMARY,
  GOOD_FOR_CHILDREN,
  GOOD_FOR_GROUPS,
  GOOD_FOR_WATCHING_SPORTS,
  GOOGLE_MAPS_LINKS,
  GOOGLE_MAPS_URI,
  ICON_BACKGROUND_COLOR,
  ICON_MASK_URL,
  ID,
  INTERNATIONAL_PHONE_NUMBER,
  LIVE_MUSIC,
  LOCATION,
  MENU_FOR_CHILDREN,
  NATIONAL_PHONE_NUMBER,
  NEIGHBORHOOD_SUMMARY,
  OPENING_HOURS,
  OUTDOOR_SEATING,
  PARKING_OPTIONS,
  PAYMENT_OPTIONS,
  PHOTO_METADATAS,
  PLUS_CODE,
  PRICE_LEVEL,
  PRIMARY_TYPE,
  PRIMARY_TYPE_DISPLAY_NAME,
  PURE_SERVICE_AREA_BUSINESS,
  RATING,
  RESERVABLE,
  RESOURCE_NAME,
  RESTROOM,
  REVIEWS,
  REVIEW_SUMMARY,
  SECONDARY_OPENING_HOURS,
  SERVES_BEER,
  SERVES_BREAKFAST,
  SERVES_BRUNCH,
  SERVES_COCKTAILS,
  SERVES_COFFEE,
  SERVES_DESSERT,
  SERVES_DINNER,
  SERVES_LUNCH,
  SERVES_VEGETARIAN_FOOD,
  SERVES_WINE,
  SHORT_FORMATTED_ADDRESS,
  SUB_DESTINATIONS,
  TAKEOUT,
  TYPES,
  USER_RATING_COUNT,
  UTC_OFFSET,
  VIEWPORT,
  WEBSITE_URI,
}

class FetchPlaceRequest {
  String placeId;
  List<PlaceField> placeFields;

  FetchPlaceRequest({required this.placeId, required this.placeFields});
}

class FetchPlaceResponse {
  Place place;

  FetchPlaceResponse(this.place);
}

class SearchByTextRequest {
  String textQuery;
  List<PlaceField> placeFields;
  String? includedType;
  int? maxResultCount;
  double? minRating;
  bool? isOpenNow;
  List<int?>? priceLevels;
  bool? strictTypeFiltering;
  LatLngBounds? locationBias;
  LatLngBounds? locationRestriction;
  RankPreference? rankPreference;

  SearchByTextRequest({
    required this.textQuery,
    required this.placeFields,
    this.includedType,
    this.maxResultCount,
    this.minRating,
    this.isOpenNow,
    this.priceLevels,
    this.strictTypeFiltering,
    this.locationBias,
    this.locationRestriction,
  });
}

class SearchByTextResponse {
  List<Place?> places;

  SearchByTextResponse(this.places);
}

class SearchByNearbyRequest {
  CircularBounds locationRestriction;
  List<PlaceField> placeFields;
  List<String?>? includedTypes;
  List<String?>? excludedTypes;
  List<String?>? includedPrimaryTypes;
  List<String?>? excludedPrimaryTypes;
  int? maxResultCount;
  SearchByNearbyRankPreference? rankPreference;

  SearchByNearbyRequest({
    required this.locationRestriction,
    required this.placeFields,
    this.includedTypes,
    this.excludedTypes,
    this.includedPrimaryTypes,
    this.excludedPrimaryTypes,
    this.maxResultCount,
    this.rankPreference,
  });
}

class SearchByNearbyResponse {
  List<Place?> places;

  SearchByNearbyResponse(this.places);
}

enum SearchByNearbyRankPreference { DISTANCE, POPULARITY }

enum BusinessStatus { OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY }

enum DayOfWeek {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY,
}

enum BooleanPlaceAttributeValue { UNKNOWN, TRUE, FALSE }

class LatLng {
  double lat;
  double lng;

  LatLng({required this.lat, required this.lng});
}

class LatLngBounds {
  LatLng southwest;
  LatLng northeast;

  LatLngBounds({required this.southwest, required this.northeast});
}

class CircularBounds {
  LatLng center;
  double radius;

  CircularBounds({required this.center, required this.radius});
}

class AddressComponent {
  String name;
  String shortName;
  List<String?> types;

  AddressComponent({
    required this.name,
    required this.shortName,
    required this.types,
  });
}

class AddressComponents {
  List<AddressComponent?> components;

  AddressComponents({required this.components});
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});
}

class LocalTime {
  int hours;
  int minutes;

  LocalTime({required this.hours, required this.minutes});
}

class TimeOfWeek {
  DayOfWeek day;
  LocalTime time;

  TimeOfWeek({required this.day, required this.time});
}

class Period {
  TimeOfWeek? open;
  TimeOfWeek? close;

  Period({this.open, this.close});
}

class OpeningHours {
  List<Period?> periods;
  List<String?> weekdayText;

  OpeningHours({required this.periods, required this.weekdayText});
}

class PhotoMetadata {
  int width;
  int height;
  String attributions;
  List<AuthorAttribution> authorAttributions;

  PhotoMetadata({
    required this.width,
    required this.height,
    required this.attributions,
    required this.authorAttributions,
  });
}

class AuthorAttribution {
  String? name;
  String? uri;
  String? photoUri;

  AuthorAttribution({this.name, this.uri, this.photoUri});
}

class Review {
  String? name;
  String? relativePublishTimeDescription;
  double? rating;
  String? text;
  AuthorAttribution? authorAttribution;
  String? publishTime;

  Review({
    this.name,
    this.relativePublishTimeDescription,
    this.rating,
    this.text,
    this.authorAttribution,
    this.publishTime,
  });
}

class AccessibilityOptions {
  BooleanPlaceAttributeValue? wheelchairAccessibleEntrance;
  BooleanPlaceAttributeValue? wheelchairAccessibleRestroom;
  BooleanPlaceAttributeValue? wheelchairAccessibleSeating;
  BooleanPlaceAttributeValue? wheelchairAccessibleParking;

  AccessibilityOptions({
    this.wheelchairAccessibleEntrance,
    this.wheelchairAccessibleRestroom,
    this.wheelchairAccessibleSeating,
    this.wheelchairAccessibleParking,
  });
}

class ParkingOptions {
  BooleanPlaceAttributeValue? freeParkingLot;
  BooleanPlaceAttributeValue? paidParkingLot;
  BooleanPlaceAttributeValue? freeStreetParking;
  BooleanPlaceAttributeValue? paidStreetParking;
  BooleanPlaceAttributeValue? valetParking;
  BooleanPlaceAttributeValue? freeGarageParking;
  BooleanPlaceAttributeValue? paidGarageParking;

  ParkingOptions({
    this.freeParkingLot,
    this.paidParkingLot,
    this.freeStreetParking,
    this.paidStreetParking,
    this.valetParking,
    this.freeGarageParking,
    this.paidGarageParking,
  });
}

class PaymentOptions {
  BooleanPlaceAttributeValue? acceptsCreditCards;
  BooleanPlaceAttributeValue? acceptsDebitCards;
  BooleanPlaceAttributeValue? acceptsCashOnly;
  BooleanPlaceAttributeValue? acceptsNfc;

  PaymentOptions({
    this.acceptsCreditCards,
    this.acceptsDebitCards,
    this.acceptsCashOnly,
    this.acceptsNfc,
  });
}

class ContentBlock {
  String? content;
  String? contentLanguageCode;
  List<String>? referencedPlaceResourceNames;
  List<String>? referencedPlaceIds;

  ContentBlock({
    required this.content,
    required this.contentLanguageCode,
    required this.referencedPlaceResourceNames,
    required this.referencedPlaceIds,
  });
}

class EvChargeAmenitySummary {
  ContentBlock overview;
  ContentBlock? coffee;
  ContentBlock? restaurant;
  ContentBlock? store;
  String? flagContentUri;
  String? disclosureText;
  String? disclosureTextLanguageCode;

  EvChargeAmenitySummary({
    required this.overview,
    this.coffee,
    this.restaurant,
    this.store,
    this.flagContentUri,
    this.disclosureText,
    this.disclosureTextLanguageCode,
  });
}

enum EVConnectorType {
  EV_CONNECTOR_TYPE_UNSPECIFIED,
  EV_CONNECTOR_TYPE_OTHER,
  EV_CONNECTOR_TYPE_J1772,
  EV_CONNECTOR_TYPE_TYPE_2,
  EV_CONNECTOR_TYPE_CHADEMO,
  EV_CONNECTOR_TYPE_CCS_COMBO_1,
  EV_CONNECTOR_TYPE_CCS_COMBO_2,
  EV_CONNECTOR_TYPE_TESLA,
  EV_CONNECTOR_TYPE_UNSPECIFIED_GB_T,
  EV_CONNECTOR_TYPE_UNSPECIFIED_WALL_OUTLET,
  EV_CONNECTOR_TYPE_NACS,
}

class ConnectorAggregation {
  EVConnectorType type;
  double maxChargeRateKw;
  int count;
  int? availableCount;
  int? outOfServiceCount;
  int? availabilityLastUpdateTime;

  ConnectorAggregation({
    required this.type,
    required this.maxChargeRateKw,
    required this.count,
    this.availableCount,
    this.outOfServiceCount,
    this.availabilityLastUpdateTime,
  });
}

class EVChargeOptions {
  int connectorCount;
  List<ConnectorAggregation> connectorAggregations;
  EVChargeOptions({
    required this.connectorCount,
    required this.connectorAggregations,
  });
}

class Money {
  String currencyCode;
  int nanos;
  int units;

  Money({required this.currencyCode, required this.nanos, required this.units});
}

enum FuelType {
  BIO_DIESEL,
  DIESEL,
  E80,
  E85,
  FUEL_TYPE_UNSPECIFIED,
  LPG,
  METHANE,
  MIDGRADE,
  PREMIUM,
  REGULAR_UNLEADED,
  SP100,
  SP91,
  SP91_E10,
  SP92,
  SP95,
  SP95_E10,
  SP98,
  SP99,
  TRUCK_DIESEL,
}

class FuelPrices {
  Money price;
  FuelType type;
  int updateTime;
  FuelPrices({
    required this.price,
    required this.type,
    required this.updateTime,
  });
}

class FuelOptions {
  List<FuelPrices> fuelPrices;
  FuelOptions({required this.fuelPrices});
}

class GenerativeSummary {
  String? overview;
  String? overviewLanguageCode;
  String? flagContentUri;
  String? disclosureText;
  String? disclosureTextLanguageCode;
  GenerativeSummary({
    this.overview,
    this.overviewLanguageCode,
    this.flagContentUri,
    this.disclosureText,
    this.disclosureTextLanguageCode,
  });
}

class GoogleMapsLinks {
  String? directionsUri;
  String? placeUri;
  String? writeAReviewUri;
  String? reviewsUri;
  String? photosUri;
  GoogleMapsLinks({
    this.directionsUri,
    this.placeUri,
    this.writeAReviewUri,
    this.reviewsUri,
    this.photosUri,
  });
}

class ReviewSummary {
  String? disclosureText;
  String? disclosureTextLanguageCode;
  String? flagContentUri;
  String? reviewsUri;
  String? text;
  String? textLanguageCode;

  ReviewSummary({
    this.disclosureText,
    this.disclosureTextLanguageCode,
    this.flagContentUri,
    this.reviewsUri,
    this.text,
    this.textLanguageCode,
  });
}

class SubDestination {
  String? name;
  String? id;
  SubDestination({this.name, this.id});
}

class Place {
  AddressComponents? addressComponents;
  String? adrFormatAddress;
  BusinessStatus? businessStatus;
  String? displayName;
  String? displayNameLanguageCode;
  String? editorialSummary;
  String? editorialSummaryLanguageCode;
  String? formattedAddress;
  String? iconMaskUrl;
  int? iconBackgroundColor;
  String? id;
  String? internationalPhoneNumber;
  LatLng? location;
  String? nationalPhoneNumber;
  OpeningHours? openingHours;
  OpeningHours? currentOpeningHours;
  List<OpeningHours?>? secondaryOpeningHours;
  List<OpeningHours?>? currentSecondaryOpeningHours;
  List<PhotoMetadata?>? photoMetadatas;
  PlusCode? plusCode;
  int? priceLevel;
  double? rating;
  List<Review?>? reviews;
  List<String?>? types;
  int? userRatingCount;
  int? utcOffsetMinutes;
  LatLngBounds? viewport;
  String? websiteUri;
  String? googleMapsUri;
  AccessibilityOptions? accessibilityOptions;
  ParkingOptions? parkingOptions;
  PaymentOptions? paymentOptions;
  String? primaryType;
  String? primaryTypeDisplayName;
  String? primaryTypeDisplayNameLanguageCode;
  String? resourceName;
  String? shortFormattedAddress;
  EvChargeAmenitySummary? evChargeAmenitySummary;
  EVChargeOptions? evChargeOptions;
  FuelOptions? fuelOptions;
  GenerativeSummary? generativeSummary;
  GoogleMapsLinks? googleMapsLinks;
  ReviewSummary? reviewSummary;
  List<SubDestination?>? subDestinations;

  // Boolean Attribute Values
  BooleanPlaceAttributeValue? curbsidePickup;
  BooleanPlaceAttributeValue? delivery;
  BooleanPlaceAttributeValue? dineIn;
  BooleanPlaceAttributeValue? goodForChildren;
  BooleanPlaceAttributeValue? goodForGroups;
  BooleanPlaceAttributeValue? goodForWatchingSports;
  BooleanPlaceAttributeValue? liveMusic;
  BooleanPlaceAttributeValue? menuForChildren;
  BooleanPlaceAttributeValue? outdoorSeating;
  BooleanPlaceAttributeValue? reservable;
  BooleanPlaceAttributeValue? restroom;
  BooleanPlaceAttributeValue? servesBeer;
  BooleanPlaceAttributeValue? servesBreakfast;
  BooleanPlaceAttributeValue? servesBrunch;
  BooleanPlaceAttributeValue? servesCocktails;
  BooleanPlaceAttributeValue? servesCoffee;
  BooleanPlaceAttributeValue? servesDessert;
  BooleanPlaceAttributeValue? servesDinner;
  BooleanPlaceAttributeValue? servesLunch;
  BooleanPlaceAttributeValue? servesVegetarianFood;
  BooleanPlaceAttributeValue? servesWine;
  BooleanPlaceAttributeValue? takeout;
  BooleanPlaceAttributeValue? allowsDogs;
  BooleanPlaceAttributeValue? pureServiceAreaBusiness;

  Place({
    this.addressComponents,
    this.adrFormatAddress,
    this.businessStatus,
    this.displayName,
    this.displayNameLanguageCode,
    this.editorialSummary,
    this.editorialSummaryLanguageCode,
    this.formattedAddress,
    this.iconMaskUrl,
    this.iconBackgroundColor,
    this.id,
    this.internationalPhoneNumber,
    this.location,
    this.nationalPhoneNumber,
    this.openingHours,
    this.currentOpeningHours,
    this.secondaryOpeningHours,
    this.currentSecondaryOpeningHours,
    this.photoMetadatas,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reviews,
    this.types,
    this.userRatingCount,
    this.utcOffsetMinutes,
    this.viewport,
    this.websiteUri,
    this.googleMapsUri,
    this.accessibilityOptions,
    this.parkingOptions,
    this.paymentOptions,
    this.primaryType,
    this.primaryTypeDisplayName,
    this.primaryTypeDisplayNameLanguageCode,
    this.resourceName,
    this.shortFormattedAddress,
    this.evChargeAmenitySummary,
    this.evChargeOptions,
    this.fuelOptions,
    this.generativeSummary,
    this.googleMapsLinks,
    this.reviewSummary,
    this.subDestinations,
    this.curbsidePickup,
    this.delivery,
    this.dineIn,
    this.goodForChildren,
    this.goodForGroups,
    this.goodForWatchingSports,
    this.liveMusic,
    this.menuForChildren,
    this.outdoorSeating,
    this.reservable,
    this.restroom,
    this.servesBeer,
    this.servesBreakfast,
    this.servesBrunch,
    this.servesCocktails,
    this.servesCoffee,
    this.servesDessert,
    this.servesDinner,
    this.servesLunch,
    this.servesVegetarianFood,
    this.servesWine,
    this.takeout,
    this.allowsDogs,
    this.pureServiceAreaBusiness,
  });
}
